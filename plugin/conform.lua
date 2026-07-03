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
        odin = { "odinfmt" },
        -- cs = { "csharpier" },
    },
    formatters = {
        odinfmt = {
            cwd = function(_, ctx)
                return ctx.dirname
            end,
            append_args = function(_, ctx)
                if vim.fs.find("odinfmt.json", { path = ctx.dirname, upward = true })[1] then
                    return {}
                end
                return { "-config:" .. vim.fn.expand("~/.config/ols/odinfmt.json") }
            end,
        },
    },
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
})
