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
    },
    config = function()
        local theme = require "lualine.themes.auto"
        local git_blame = require "gitblame"
        require("lualine").setup {
            options = {
                theme = theme,
                globalstatus = true
            },
            sections = {
                lualine_c = { "filename" },
                -- Show the git blame int the status line.
                lualine_x = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available } },
                lualine_y = { "filetype" },
                lualine_z = { "location" }
            },
        }
    end,
}
