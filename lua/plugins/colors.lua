local opts = {
    theme = "wave",
    commentStyle = { italic = false },
    keywordStyle = { italic = false },

    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none",
                }
            }
        }
    }
}
return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("kanagawa").setup(opts);
        vim.cmd("colorscheme kanagawa");
        vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffe5b4', bold = true })
        vim.api.nvim_set_hl(0, 'CmpGhostText', { fg = "#64778A" })
    end
};
