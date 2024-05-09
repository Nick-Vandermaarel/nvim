return {
    -- lspconfig
    {
        'neovim/nvim-lspconfig',
        event = "VeryLazy",
        dependencies = {
            { "folke/neodev.nvim",  opts = {} },
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

            local function organizeImports()
                local params = {
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                    title = ""
                }
                vim.lsp.buf.execute_command(params)
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
                    'tsserver',
                    'volar',
                    'html',
                    'rust_analyzer'
                },
                handlers = {
                    default_setup,
                    tsserver = function()
                        require('lspconfig').tsserver.setup({
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
                            commands = {
                                OrganizeImports = {
                                    organizeImports,
                                    description = "Organize Imports"
                                }
                            },
                        })
                    end,
                }
            })
        end,
    },
    {
        {
            'hrsh7th/nvim-cmp',
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",           -- source for text in buffer
                "hrsh7th/cmp-path",             -- source for file system paths
                "L3MON4D3/LuaSnip",             -- snippet engine
                "saadparwaiz1/cmp_luasnip",     -- for autocompletion
                "rafamadriz/friendly-snippets", -- useful snippets
                "onsails/lspkind.nvim",         -- vs-code like pictograms
                {                               -- Github Copilot suggestions
                    "zbirenbaum/copilot-cmp",
                    config = function()
                        require("copilot_cmp").setup()
                    end
                },
            },
            config = function()
                local cmp = require('cmp')
                local cmp_select = { behavior = cmp.SelectBehavior.Select }

                local luasnip = require("luasnip")
                local lspkind = require("lspkind")

                require("luasnip.loaders.from_vscode").lazy_load()

                cmp.setup({
                    sources = cmp.config.sources({
                        { name = "copilot" },
                        { name = 'nvim_lsp' },
                        { name = "luasnip" },
                        { name = "path" },
                    }),
                    formatting = {
                        format = lspkind.cmp_format({
                            with_text = true,
                            maxwidth = 50,
                            ellipsis_char = "..."
                        }),
                    },
                    window = {
                        documentation = cmp.config.window.bordered(),
                        completion = cmp.config.window.bordered(),
                    },
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        -- Select the next item
                        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                        -- select the previous item
                        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

                        -- Accept the completion. Default is <c-y>
                        ['<C-y>'] = cmp.mapping.confirm({ select = true }),

                        -- Manually trigger a completion from nvim-cmp
                        ['<C-Space>'] = cmp.mapping.complete(),
                    }),
                })

                -- Add parentheses after selecting function or method item.
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on(
                    "confirm_done",
                    cmp_autopairs.on_confirm_done()
                )
            end
        },
        {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            event = "InsertEnter",
            config = function()
                require("copilot").setup({
                    suggestion = { enabled = false },
                    panel = { enabled = false }
                })
            end
        },
    }
}
