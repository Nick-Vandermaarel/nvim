return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        {
            "f-person/git-blame.nvim",
            config = function()
                vim.g.gitblame_display_virtual_text = 0 -- Remove virtual text from the buffer.
                vim.g.gitblame_message_when_not_committed = "Not commited"
                vim.g.gitblame_date_format = "%Y-%m-%d %H:%M"
                vim.g.gitblame_enabled = 1
            end
        },
        "otavioschwanck/arrow.nvim",
    },
    config = function()
        local theme = require "lualine.themes.auto"
        local git_blame = require "gitblame"
        local arrow_sl = require "arrow.statusline"

        require("lualine").setup {
            options = {
                theme = theme,
                globalstatus = true,
                disabled_filetypes = {
                    "snacks_dashboard",
                    "lazy",
                    "mason",
                    "NvimTree"
                }
            },
            sections = {
                lualine_b = {
                    "branch", "diff", "filename",
                    {
                        "diagnostics",
                        update_in_insert = true
                    },
                },
                lualine_c = {
                    -- Show the arrow marker if the current buffer is bookmarked.
                    function()
                        return arrow_sl.text_for_statusline_with_icons()
                    end
                },
                -- Show the git blame int the status line.
                lualine_x = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available } },
                lualine_y = { "filetype" },
                lualine_z = { "location" }
            },
        }
    end,
}
