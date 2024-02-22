local theme = require "lualine.themes.auto"
local git_blame = require "gitblame"
vim.g.gitblame_display_virtual_text = 0 -- Remove virtual text from the buffer.
vim.g.gitblame_message_when_not_committed = "Not commited"
vim.g.gitblame_date_format = "%Y-%m-%d %H:%M"

-- Show the git blame int the status line.

require("lualine").setup {
    options = { theme = theme },
    sections = {
        lualine_c = { "filename" },
        lualine_x = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available } },
        lualine_y = { "filetype" },
        lualine_z = { "location" }
    }
}
