require("kanagawa").setup({
    theme = "wave",
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
})

vim.cmd("colorscheme kanagawa")

require("colorizer").setup {
    html = { names = false } -- Disabled name parsing
}
