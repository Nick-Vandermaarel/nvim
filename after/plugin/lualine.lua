local theme = require "lualine.themes.auto"
local git_blame = require "gitblame"
vim.g.gitblame_display_virtual_text = 0 -- Remove virtual text from the buffer.

require("lualine").setup {
    options = { theme = theme },
    sections = {
        -- Show the bit blame in lua line.
        lualine_c = {{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }}
    }
}
