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
                local makeDiagnosticColor = function(color)
                    local c = require("kanagawa.lib.color")
                    return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
                end

                return {
                    -- Right-click menu (Pmenu) - darker version
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                    BlinkCmpMenuBorder = { fg = "", bg = "" },

                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },
                    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                    -- Popular plugins that open floats will link to NormalFloat by default;
                    -- set their background accordingly if you wish to keep them dark and borderless
                    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                    DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
                    DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
                    DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
                    DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

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
