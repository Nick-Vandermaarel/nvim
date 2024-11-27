return {
    "yioneko/nvim-cmp",
    branch = "perf",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",                  -- source for text in buffer
        "hrsh7th/cmp-path",                    -- source for file system paths
        "hrsh7th/cmp-nvim-lsp-signature-help", -- source for displaying function signatures
        "onsails/lspkind.nvim",                -- vs-code like pictograms
    },
    opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skil loading LuaLs completions
        })

        return opts;
    end,
    config = function()
        local cmp = require('cmp')
        local lspkind = require("lspkind")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            sources = cmp.config.sources({
                { name = "nvim_lsp_signature_help" },
                { name = 'nvim_lsp' },
                { name = "path" },
            }),
            window = {
                documentation = cmp.config.window.bordered(),
                completion = cmp.config.window.bordered(),
            },
            experimental = {
                ghost_text = { hl_group = "CmpGhostText" },
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<tab>'] = cmp.mapping.confirm({ select = true }),

                -- Manually trigger a completion from nvim-cmp
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 50,
                    elipsis_char = "...",
                })
            }
        })

        -- Add parentheses after selecting function or method item.
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done()
        )
    end
}
