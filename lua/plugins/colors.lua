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

        -- Blink completion menu highlights
        -- Main menu components
        vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = palette.zen0 })                                                   -- Darker background using zen0
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = palette.inkBlue2, bg = "NONE" })                            -- Soft blue border
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { fg = palette.fujiWhite, bg = palette.zenBlue2, bold = true }) -- Selection with zenBlue2

        -- Scrollbar
        vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarThumb', { bg = palette.inkBlue2 }) -- Matching border color
        vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarGutter', { bg = palette.zen0 })

        -- Item components
        vim.api.nvim_set_hl(0, 'BlinkCmpLabel', { fg = palette.oldWhite })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { fg = palette.inkRed, strikethrough = true })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { fg = palette.inkPink, bold = true }) -- Subtle pink for matches
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDetail', { fg = palette.inkWhite })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDescription', { fg = palette.katanaGray })

        -- Kind/icons
        vim.api.nvim_set_hl(0, 'BlinkCmpKind', { fg = palette.zenAqua2 })                       -- Zen aqua for kinds
        vim.api.nvim_set_hl(0, 'BlinkCmpSource', { fg = palette.springViolet1, italic = true }) -- Violet for source
        vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = palette.inkGray1, italic = true })

        -- Documentation
        vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { bg = palette.zen0 })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = palette.inkBlue2, bg = "NONE" }) -- Match menu border
        vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', { fg = palette.katanaGray })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocCursorLine', { bg = palette.zen2 })

        -- Signature help
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { bg = palette.zen0 })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = palette.inkBlue2, bg = "NONE" })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpActiveParameter',
            { fg = palette.inkPink, bg = palette.zen3, bold = true }) -- Pink on zen3 background

        -- Right-click menu (Pmenu)
        vim.api.nvim_set_hl(0, 'Pmenu', { fg = palette.oldWhite, bg = palette.zen0 })                      -- Match BlinkCmpMenu
        vim.api.nvim_set_hl(0, 'PmenuSel', { fg = palette.fujiWhite, bg = palette.zenBlue2, bold = true }) -- Match selection
        vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = palette.zen0 })                                         -- Match scrollbar gutter
        vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = palette.inkBlue2 })                                    -- Match scrollbar thumb

        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = palette.zenAqua2 })

        -- Private cs fields
        vim.api.nvim_set_hl(0, '@lsp.type.field.cs', { fg = palette.oldWhite })
    end
}
