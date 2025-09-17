return {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("kanso").setup({
            keywordStyle = { italic = false },
            overrides = function(colors)
                return {
                    WinSeparator = { fg = colors.palette.zenBg3 },
                    -- Right-click menu (Pmenu) - darker version
                    Pmenu = { fg = colors.palette.gray2, bg = colors.palette.zenBg0 },
                    PmenuSel = { fg = colors.palette.fg, bg = colors.palette.zenBg2, bold = true },
                    PmenuSbar = { bg = colors.palette.zenBg0 },
                    PmenuThumb = { bg = colors.palette.gray4 },
                    -- Private cs fields
                    ['@lsp.type.field.cs'] = { fg = colors.palette.fg },
                    ['@lsp.type.constant.cs'] = { fg = colors.palette.orange },

                    -- LSP Document Highlights - subtle approach
                    LspReferenceText = { bg = colors.palette.zenBg1 },
                    LspReferenceRead = { bg = colors.palette.zenBg1 },
                    LspReferenceWrite = { bg = colors.palette.zenBg3, bold = true },
                }
            end,
        })
        vim.cmd("colorscheme kanso-zen")
    end
}
