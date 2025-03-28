return {
    -- Must be setup before the lspconfig
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {}
    },
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        config = function()
            local lspUtils = require("nvdm.lspUtils");
            require("roslyn").setup({
                filewatching = "auto",
                ---@diagnostic disable-next-line: missing-fields
                config = {
                    settings = {
                        ['csharp|code_lens'] = {
                            dotnet_enable_references_code_lens = true,
                        },
                        ["csharp|completion"] = {
                            dotnet_show_completion_items_from_unimported_namespaces = true,
                        },
                        ["csharp|inlay_hints"] = {
                            csharp_enable_inlay_hints_for_implicit_object_creation = true,
                            csharp_enable_inlay_hints_for_implicit_variable_types = true,
                            csharp_enable_inlay_hints_for_types = true,
                        },
                        ["csharp|formatting"] = {
                            dotnet_organize_imports_on_format = true,
                        },
                    },
                    on_attach = function(client, bufnr)
                        lspUtils.onAttach({ client = client, bufnr = bufnr });
                        lspUtils.roslynSemanticHighlights(client);
                    end,
                },
            });
        end
    },

    -- lspconfig
    {
        'neovim/nvim-lspconfig',
        event = "VeryLazy",
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspUtils = require("nvdm.lspUtils");
            local lsp_capabilities = lspUtils.default_capabilities();
            -- until nvim 0.11
            lsp_capabilities = require('blink.cmp').get_lsp_capabilities(lsp_capabilities)

            local handlers = {
                ["textDocument/hover"] = vim.lsp.with(
                    vim.lsp.handlers.hover,
                    { border = "rounded" }
                ),
                ["textDocument/signatureHelp"] = vim.lsp.with(
                    vim.lsp.handlers.signature_help,
                    { border = "rounded" }
                )
            }

            -- Apply handlers once
            for k, v in pairs(handlers) do
                vim.lsp.handlers[k] = v
            end

            local default_setup = function(server)
                require('lspconfig')[server].setup({
                    capabilities = lsp_capabilities,
                    handlers = handlers
                })
            end

            -- LSP Attach AutoCMD
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = "LSP actions",
                callback = function(event)
                    lspUtils.onAttach(event);
                end
            })
            -- Change the Diagnostic symbols in the sign column (gutter)
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            require('mason').setup({
                ui = {
                    border = "rounded"
                },
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    "lua_ls",
                    'ts_ls',
                    'volar',
                    'html',
                },
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
                handlers = {
                    default_setup,
                    ts_ls = function()
                        -- Lazy path resolution - only compute when needed
                        local vue_typescript_plugin_path = (function()
                            local mason_path = vim.fn.stdpath("data") .. '/mason/packages/vue-language-server'

                            for _, path in ipairs({
                                mason_path .. '/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin',
                                mason_path .. '/node_modules/@vue/typescript-plugin'
                            }) do
                                if vim.fn.isdirectory(path) == 1 then
                                    return path
                                end
                            end

                            return mason_path .. '/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin'
                        end)()

                        require('lspconfig')["ts_ls"].setup({
                            capabilities = lsp_capabilities,
                            init_options = {
                                plugins = {
                                    {
                                        name = "@vue/typescript-plugin",
                                        location = vue_typescript_plugin_path,
                                        languages = { "typescript", "vue" },
                                    }
                                }
                            },
                            filetypes = { "typescript", "javascript", "vue" },
                        })
                    end,

                    volar = function()
                        require("lspconfig").volar.setup {
                            capabilities = lsp_capabilities,
                            handlers = handlers
                        }
                    end,
                }
            })
        end,
    }
}
