return {
    -- formatter
    'stevearc/conform.nvim',
    event = "BufReadPre",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                javascript = { { "prettierd" } },
                typescript = { { "prettierd" } },
                vue = { { "prettierd" } },
                scss = { { "prettierd" } },
                json = { { "prettierd" } },
                html = { { "prettierd" } },
                css = { { "prettierd" } },
                markdown = { { "prettierd" } },
                -- cs = { { "csharpier" } },
            },
            format_on_save = {
                async = false,
                timeout_ms = 5000,
                lsp_fallback = true,
            }
        })
    end,
}
