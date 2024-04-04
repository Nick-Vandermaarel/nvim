return {
    -- formatter
    {
        'stevearc/conform.nvim',
        lazy = true,
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
                    csharp = { { "csharpier" }},
                },
                format_on_save = {
                    async = true,
                    lsp_fallback = true,
                }
            })
        end,
    },
}
