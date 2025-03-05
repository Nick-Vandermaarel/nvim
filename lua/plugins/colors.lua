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

        -- -- Blink
        local colors = require("kanagawa.colors")
        vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = colors.sumiInk2 })
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = colors.springBlue, bg = colors.sumiInk2 })
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { fg = colors.fujiWhite, bg = colors.waveBlue2 })

        -- Scrollbar
        vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarThumb', { bg = colors.fujiGray })
        vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarGutter', { bg = colors.sumiInk4 })

        -- Item components
        vim.api.nvim_set_hl(0, 'BlinkCmpLabel', { fg = colors.fujiWhite })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { fg = colors.autumnRed, strikethrough = true })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { fg = colors.sakuraPink, bold = true })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDetail', { fg = colors.oldWhite })
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDescription', { fg = colors.fujiGray })

        -- Kind/icons
        vim.api.nvim_set_hl(0, 'BlinkCmpKind', { fg = colors.springBlue })
        vim.api.nvim_set_hl(0, 'BlinkCmpSource', { fg = colors.oniViolet, italic = true })
        vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = colors.fujiGray, italic = true })

        -- Documentation
        vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { bg = colors.sumiInk3 })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { fg = colors.fujiGray, bg = colors.sumiInk3 })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator', { fg = colors.fujiGray })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocCursorLine', { bg = colors.waveBlue1 })

        -- Signature help
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { bg = colors.sumiInk3 })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = colors.fujiGray, bg = colors.sumiInk3 })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpActiveParameter',
            { fg = colors.oniViolet, bg = colors.waveBlue1, bold = true })
    end
};
