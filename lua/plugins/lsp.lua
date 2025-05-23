return {
    -- Must be setup before the lspconfig
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {}
    },
    {
        "seblj/roslyn.nvim",
        ft = { "cs", "sln" },
        config = function()
            -- Required until rosln lspconfig update is live.
            local lsp_capabilities = require('blink.cmp').get_lsp_capabilities({}, true)

            require("roslyn").setup({
                -- For connecting to Godot Engine.
                cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),

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
                            dotnet_show_name_completion_suggestions = true,
                        },
                        ["csharp|formatting"] = {
                            dotnet_organize_imports_on_format = true,
                        },
                        ["csharp|symbol_search"] = {
                            dotnet_search_reference_assemblies = true,
                        }
                    },
                },
            });
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim' },
            { 'mason-org/mason-lspconfig.nvim' },
        },
        lazy = false,
        config = function()
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
                update_in_insert = true
            })

            require('mason').setup({
                registries = {
                    'github:Crashdummyy/mason-registry',
                    'github:mason-org/mason-registry'
                }
            })
            require('mason-lspconfig').setup({
                automatic_enable = true,
            })

            local lspUtils = require("nvdm.lspUtils");

            -- LSP Attach AutoCMD
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = "LSP actions",
                callback = function(event)
                    lspUtils.onAttach(event);
                end
            })

            vim.lsp.config("vue_ls", {
                init_options = {
                    vue = {
                        hybridMode = false
                    }
                },
                settings = {
                    typescript = {
                        inlayHints = {
                            enumMemberValues = {
                                enabled = true,
                            },
                            functionLikeReturnTypes = {
                                enabled = true,
                            },
                            propertyDeclarationTypes = {
                                enabled = true,
                            },
                            parameterTypes = {
                                enabled = true,
                                suppressWhenArgumentMatchesName = true,
                            },
                            variableTypes = {
                                enabled = true,
                            }
                        }
                    }
                }
            })

            local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
            local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server/node_modules"
            vim.lsp.config("ts_ls", {
                settings = {
                    ["ts_ls"] = {
                        init_options = {
                            plugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location = volar_path,
                                    languages = { "vue" },
                                },
                            },
                        }
                    },
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                }
            })
        end
    }
}
