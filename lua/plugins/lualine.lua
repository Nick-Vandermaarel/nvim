return {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        "otavioschwanck/arrow.nvim",
    },
    config = function()
        local theme = require "lualine.themes.auto"
        local arrow_sl = require "arrow.statusline"

        require("lualine").setup {
            options = {
                theme = theme,
                globalstatus = true,
                disabled_filetypes = {
                    "snacks_dashboard",
                    "lazy",
                    "mason",
                },
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_b = {
                    "branch", "diff", "diagnostics",
                },
                lualine_c = {
                    "filename",
                    -- Show the arrow marker if the current buffer is bookmarked.
                    function()
                        return arrow_sl.text_for_statusline_with_icons()
                    end
                },
                lualine_x = {},
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
        }
    end,
}
