return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            "f-person/git-blame.nvim",
            opt = true
        },
        config = function()
            local theme = require "lualine.themes.auto"
            local git_blame = require "gitblame"
            require("lualine").setup {
                options = {

                    -- Show the git blame int the status line.
                    options = { theme = theme },
                    sections = {
                        lualine_c = { "filename" },
                        lualine_x = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available } },
                        lualine_y = { "filetype" },
                        lualine_z = { "location" }
                    }
                }
            }
        end,
    },
}
