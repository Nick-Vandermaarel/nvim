local opts = {
    theme = "wave",
    commentStyle = { italic = true },
    keywordStyle = { italic = false },

    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    },
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

        local colors = require("kanagawa.colors").setup({ theme = "wave" })
        local theme = colors.theme
        local palette = colors.palette

        -- Blink completion menu highlights
        -- Main menu components
        vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = theme.ui.bg_m3 })                                                  -- Darker background
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = palette.crystalBlue, bg = "NONE" })                          -- Brighter border
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { fg = palette.fujiWhite, bg = palette.waveBlue2, bold = true }) -- More vibrant selection

        -- Scrollbar
        vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarThumb', { bg = palette.crystalBlue }) -- Brighter scrollbar
        vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarGutter', { bg = theme.ui.bg_m1 })

        -- Item components
        vim.api.nvim_set_hl(0, 'BlinkCmpLabel', { fg = theme.ui.fg })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { fg = palette.autumnRed, strikethrough = true })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { fg = palette.sakuraPink, bold = true }) -- More vibrant matches
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDetail', { fg = palette.oldWhite })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDescription', { fg = palette.fujiGray })

        -- Kind/icons
        vim.api.nvim_set_hl(0, 'BlinkCmpKind', { fg = palette.autumnGreen })                -- More vibrant kind icons
        vim.api.nvim_set_hl(0, 'BlinkCmpSource', { fg = palette.oniViolet, italic = true }) -- More vibrant source
        vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = palette.fujiGray, italic = true })

        -- Documentation
        vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { bg = theme.ui.bg_m3 })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = palette.crystalBlue, bg = "NONE" }) -- Match menu border color
        vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', { fg = palette.fujiGray })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocCursorLine', { bg = theme.ui.bg_m1 })

        -- Signature help
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { bg = theme.ui.bg_m3 })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = palette.crystalBlue, bg = "NONE" }) -- Match menu border color
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpActiveParameter',
            { fg = palette.sakuraPink, bg = theme.ui.bg_p1, bold = true })                               -- More vibrant active parameter

        -- Right-click menu (Pmenu) styling with Kanagawa wave theme
        vim.api.nvim_set_hl(0, 'Pmenu', { fg = theme.ui.fg, bg = theme.ui.bg_m3 })                          -- Match BlinkCmpMenu darker background
        vim.api.nvim_set_hl(0, 'PmenuSel', { fg = palette.fujiWhite, bg = palette.waveBlue2, bold = true }) -- Match your selection highlight
        vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = theme.ui.bg_m1 })                                        -- Match your scrollbar gutter
        vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = palette.crystalBlue })                                  -- Match your scrollbar thumb
    end
};
