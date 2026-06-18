vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
    formatters_by_ft = {
        javascript = { "oxfmt" },
        typescript = { "oxfmt" },
        vue = { "oxfmt" },
        scss = { "oxfmt" },
        json = { "oxfmt" },
        html = { "oxfmt" },
        css = { "oxfmt" },
        markdown = { "oxfmt" },
        lua = { "stylua" },
        -- cs = { "csharpier" },
    },
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})
