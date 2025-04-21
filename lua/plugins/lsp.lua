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
            local lsp_capabilities = lspUtils.default_capabilities();
            -- until nvim 0.11
            lsp_capabilities = require('blink.cmp').get_lsp_capabilities(lsp_capabilities)

            require("roslyn").setup({
                filewatching = "auto",
                ---@diagnostic disable-next-line: missing-fields
                config = {
                    capabilities = lsp_capabilities,
                    settings = {
                        ['csharp|code_lens'] = {
                            dotnet_enable_references_code_lens = true,
                        },
                        ["csharp|completion"] = {
                            dotnet_show_completion_items_from_unimported_namespaces = true,
                        },
                        ["csharp|inlay_hints"] = {
                            dotnet_enable_inlay_hints_for_literal_parameters = true,
                        },
                        ["csharp|formatting"] = {
                            dotnet_organize_imports_on_format = true,
                        },
                    },
                    on_attach = function(client, bufnr)
                        lspUtils.onAttach({ client = client, bufnr = bufnr });
                        if (client.server_capabilities.inlayHintProvider) then
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr });
                        end
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

            local default_setup = function(server)
                require('lspconfig')[server].setup({
                    capabilities = lsp_capabilities,
                })
            end

            -- LSP Attach AutoCMD
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = "LSP actions",
                callback = function(event)
                    lspUtils.onAttach(event);
                end
            })

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "✘",
                        [vim.diagnostic.severity.WARN] = "▲",
                        [vim.diagnostic.severity.HINT] = "⚑",
                        [vim.diagnostic.severity.INFO] = "󰋼"
                    },
                    texthl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                    }
                },
                virtual_text = true,
                underline = true,
                severity_sort = true,
                update_in_insert = false
            })

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
                        }
                    end,
                }
            })
        end,
    }
}
