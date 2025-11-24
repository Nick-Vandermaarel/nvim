return {
    -- Must be setup before the lspconfig
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {}
    },
    {
        "seblj/roslyn.nvim",
        ft = { "cs", "sln" },
        opts = {}
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim' },
            { 'mason-org/mason-lspconfig.nvim' },
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = { diagnostics = { virtual_text = false } },
        config = function()
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "●",
                        [vim.diagnostic.severity.WARN] = "●",
                        [vim.diagnostic.severity.HINT] = "●",
                        [vim.diagnostic.severity.INFO] = "●"
                    },
                    texthl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                    }
                },
                underline = true,
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
                callback = function(args)
                    lspUtils.onAttach(args);
                    local client = vim.lsp.get_client_by_id(args.data.client_id);

                    -- vim.lsp.inlay_hint.enable(true);

                    if client ~= nil then
                        -- 0.11 does not support document color yet
                        if vim.lsp.document_color and client:supports_method('textDocument/document_color') then
                            vim.lsp.document_color.enable(true, args.buf)
                        end

                        -- Semantic highlighting when hovering
                        if client.server_capabilities.documentHighlightProvider then
                            local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. args.buf,
                                { clear = true })

                            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                                group = group,
                                buffer = args.buf,
                                callback = vim.lsp.buf.document_highlight,
                            })

                            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertLeave", "BufLeave" }, {
                                group = group,
                                buffer = args.buf,
                                callback = vim.lsp.buf.clear_references,
                            })
                        end
                    end
                end
            })

            local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
                '/vue-language-server' .. '/node_modules/@vue/language-server'
            local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

            local vue_plugin = {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
                configNamespace = "typescript"
            }
            local ts_ls_config = {
                init_options = {
                    plugins = {
                        vue_plugin,
                    },
                },
                filetypes = tsserver_filetypes,
            }

            local vue_ls_config = {}

            vim.lsp.config('ts_ls', ts_ls_config)
            vim.lsp.config("vue_ls", vue_ls_config)
            vim.lsp.enable({ "ts_ls", "vue_ls" })

            vim.lsp.config("cssls", {
                settings = {
                    css = {
                        validate = true,
                        lint = {
                            unknownAtRules = "ignore",
                        }
                    }
                }
            })

            vim.lsp.config("roslyn", {
                -- cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
                settings = {
                    ['csharp|code_lens'] = {
                        dotnet_enable_references_code_lens = true,
                        dotnet_enable_tests_code_lens = true, -- Run/debug tests inline
                    },
                    ["csharp|inlay_hints"] = {
                        dotnet_enable_inlay_hints_for_parameters = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = true,  -- Shows what 'var' resolves to
                        csharp_enable_inlay_hints_for_implicit_object_creation = true, -- Shows types in 'new()'
                        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
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
                    },
                    -- ["csharp|background_analysis"] = {
                    --     dotnet_analyzer_diagnostics_scope = "fullSolution",
                    --     dotnet_compiler_diagnostics_scope = "fullSolution",
                    -- },
                },
            })
        end
    }
}
