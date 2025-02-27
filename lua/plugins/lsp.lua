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
                filewatching = true,
                ---@diagnostic disable-next-line: missing-fields
                config = {
                    setings = {
                        ['csharp|code_lens'] = {
                            dotnet_enable_references_code_lens = true,
                        }
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
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities();
            local lspUtils = require("nvdm.lspUtils");


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

            local default_setup = function(server)
                require('lspconfig')[server].setup({
                    capabilities = lsp_capabilities,
                    handlers = handlers
                })
            end

            vim.lsp.handlers = vim.tbl_extend("force", vim.lsp.handlers, handlers)

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
                        local function get_vue_typescript_plugin_path()
                            local mason_path = vim.fn.stdpath("data") .. '/mason/packages/vue-language-server'

                            -- Check both possible plugin locations
                            local possible_paths = {
                                mason_path .. '/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin',
                                mason_path .. '/node_modules/@vue/typescript-plugin'
                            }

                            for _, path in ipairs(possible_paths) do
                                if vim.fn.isdirectory(path) == 1 then
                                    return path
                                end
                            end

                            -- Fallback to the original path if none found
                            return mason_path .. '/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin'
                        end

                        local vue_typescript_plugin_path = get_vue_typescript_plugin_path()

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

                        local lspconfig = require "lspconfig"
                        lspconfig.volar.setup {}
                    end,
                }
            })
        end,
    }
}
