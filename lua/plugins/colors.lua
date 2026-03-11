-- return {
--     "webhooked/kanso.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         require("kanso").setup({
--             keywordStyle = { italic = false },
--             overrides = function(colors)
--                 return {
--                     WinSeparator = { fg = colors.palette.zenBg3 },
--                     -- Right-click menu (Pmenu) - darker version
--                     Pmenu = { fg = colors.palette.gray2, bg = colors.palette.zenBg1 },
--                     PmenuSel = { fg = colors.palette.fg, bg = colors.palette.zenBg2, bold = true },
--                     PmenuSbar = { bg = colors.palette.zenBg0 },
--                     PmenuThumb = { bg = colors.palette.gray4 },
--                     -- Private cs fields
--                     ["@lsp.type.field.cs"] = { fg = colors.palette.fg },
--                     ["@lsp.type.constant.cs"] = { fg = colors.palette.orange },
--
--                     LspReferenceText = { bg = "#2a2e3e" }, -- Subtle blue-gray
--                     LspReferenceRead = { bg = "#2a2e3e" },
--                     LspReferenceWrite = { bg = "#3e3449", bold = true, underline = true }, -- Slightly purple
--                 }
--             end,
--         })
--         vim.cmd("colorscheme kanso-ink")
--     end,
-- }

return {
    "rebelot/kanagawa.nvim",
    config = function()
        require("kanagawa").setup({
            keywordStyle = { italic = false },
            colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none",
                        },
                    },
                },
            },
            overrides = function(colors)
                local theme = colors.theme
                return {
                    -- Right-click menu (Pmenu) - darker version
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency,,
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = "#C0A36E" },
                    BlinkCmpMenuBorder = { fg = "", bg = "" },
                    --
                    -- Private cs fields
                    ["@lsp.type.field.cs"] = { fg = colors.palette.fg },
                    ["@lsp.type.constant.cs"] = { fg = colors.palette.dragonOrange2 },
                }
            end,
        })
        vim.cmd("colorscheme kanagawa-dragon")
    end,
}
