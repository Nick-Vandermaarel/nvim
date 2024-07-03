return {
    -- Must be setup before the lspconfig
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {}
    },

    {
        "seblj/roslyn.nvim",
        config = function()
            local onAttach = require("nvdm.autocmd");
            require("roslyn").setup({
                config = {
                   on_attach = onAttach,
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
                    -- "csharp_ls",
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
                "hrsh7th/cmp-buffer",                  -- source for text in buffer
                "hrsh7th/cmp-path",                    -- source for file system paths
                "hrsh7th/cmp-nvim-lsp-signature-help", -- source for displaying function signatures
                "L3MON4D3/LuaSnip",                    -- snippet engine
                "saadparwaiz1/cmp_luasnip",            -- for autocompletion
                "rafamadriz/friendly-snippets",        -- useful snippets
                "onsails/lspkind.nvim",                -- vs-code like pictograms
                {                                      -- Github Copilot suggestions
                    "zbirenbaum/copilot-cmp",
                    config = function()
                        require("copilot_cmp").setup()
                    end
                },
            },
            opts = function(_, opts)
                opts.sources = opts.sources or {}
                table.insert(opts.sources, {
                    name = "lazydev",
                    group_index = 0, -- set group index to 0 to skil loading LuaLs completions
                })
            end,
            config = function()
                local cmp = require('cmp')
                local cmp_select = { behavior = cmp.SelectBehavior.Select }

                local lspkind = require("lspkind")

                local luasnip = require("luasnip")
                require("luasnip.loaders.from_vscode").lazy_load()

                -- Tab completion fix
                local has_words_before = function()
                    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") ==
                        nil
                end

                cmp.setup({
                    sources = cmp.config.sources({
                        { name = "nvim_lsp_signature_help" },
                        { name = "copilot" },
                        { name = 'nvim_lsp' },
                        { name = "luasnip" },
                        { name = "path" },
                    }),
                    window = {
                        documentation = cmp.config.window.bordered(),
                        completion = cmp.config.window.bordered(),
                    },
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    formatting = {
                        format = lspkind.cmp_format({
                            mode = "symbol",
                            max_width = 50,
                            symbol_map = { Copilot = "" }
                        }),
                    },
                    experimental = {
                        ghost_text = true,
                    },
                    mapping = cmp.mapping.preset.insert({
                        -- Select the next item
                        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                        -- select the previous item
                        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),

                        -- Accept the completion. Default is <c-y>
                        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                        ['<tab>'] = cmp.mapping.confirm({ select = true }),

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
