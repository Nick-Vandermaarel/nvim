vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
local theme = require("lualine.themes.auto")
local dap_ui = require("nvdm.dap")

local function worktree_name()
    local worktree = vim.fn.FugitiveWorkTree()
    if worktree == nil or worktree == "" then
        return ""
    end

    return vim.fs.basename(worktree)
end

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
        lualine_a = {
            {
                dap_ui.statusline,
                cond = function()
                    return dap_ui.session() ~= nil
                end,
                color = {
                    fg = "#1f1f28",
                    bg = "#c34043",
                    gui = "bold",
                },
            },
        },
        lualine_b = {
            worktree_name,
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
