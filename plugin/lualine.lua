vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
local theme = require("lualine.themes.auto")

require("lualine").setup({
    options = {
        theme = theme,
        globalstatus = true,
        disabled_filetypes = {
            "snacks_dashboard",
            "mason",
        },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_b = {
            "branch",
            "diff",
            "diagnostics",
        },
        lualine_c = {
            "filename",
            -- Show the arrow marker if the current buffer is bookmarked.
        },
        lualine_x = {},
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
