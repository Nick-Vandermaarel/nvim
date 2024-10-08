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
                ---@diagnostic disable-next-line: missing-fields
                config = {
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

            local default_setup = function(server)
                require('lspconfig')[server].setup({
                    capabilities = lsp_capabilities,
                })
            end

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover,
                { border = "rounded" }
            )
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help,
                { border = "rounded" }
            )

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    "lua_ls",
                    'ts_ls',
                    'volar',
                    'html',
                    'rust_analyzer',
                    'tailwindcss',
                },
                handlers = {
                    default_setup,
                    ts_ls = function()
                        require('lspconfig')["ts_ls"].setup({
                            capabilities = lsp_capabilities,
                            init_options = {
                                plugins = {
                                    {
                                        name = "@vue/typescript-plugin",
                                        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                                        languages = { "typescript", "vue" },
                                    }
                                }
                            },
                            filetypes = { "typescript", "javascript", "vue" },
                        })
                    end,
                }
            })
        end,
    }
}
