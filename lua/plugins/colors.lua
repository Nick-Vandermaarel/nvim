return {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("kanso").setup({
            keywordStyle = { italic = false },
        })
        vim.cmd("colorscheme kanso-zen")

        local colors = require("kanso.colors").setup();
        local palette = colors.palette;

        -- Right-click menu (Pmenu)
        vim.api.nvim_set_hl(0, 'Pmenu', { fg = palette.oldWhite, bg = palette.zen0 })                      -- Match BlinkCmpMenu
        vim.api.nvim_set_hl(0, 'PmenuSel', { fg = palette.fujiWhite, bg = palette.zenBlue2, bold = true }) -- Match selection
        vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = palette.zen0 })                                         -- Match scrollbar gutter
        vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = palette.inkBlue2 })                                    -- Match scrollbar thumb

        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = palette.zen2 })

        -- Private cs fields
        vim.api.nvim_set_hl(0, '@lsp.type.field.cs', { fg = palette.oldWhite })
        vim.api.nvim_set_hl(0, '@lsp.type.constant.cs', { fg = '#d19a66' })
    end
}
