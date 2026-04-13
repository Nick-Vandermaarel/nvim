vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        vue = { "prettierd", "eslint_d" },
        scss = { "prettierd" },
        json = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        markdown = { "prettierd" },
        lua = { "stylua" },
        -- cs = { "csharpier" },
    },
    format_on_save = {
        timeout_ms = 5000,
        lsp_fallback = true,
    },
})
