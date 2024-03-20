-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24 bit color.
vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>]", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>'", ":NvimTreeFocus<CR>")

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        adaptive_size = true
    },
})
