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
    },
    format_on_save = {
        timeout_ms = 1000,
        async = true,
        lsp_fallback = true,
    }
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({
            bufnr = args.buf,
        })
    end,
})
