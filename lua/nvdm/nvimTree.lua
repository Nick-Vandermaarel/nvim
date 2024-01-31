-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24 bit color.
vim.opt.termguicolors = true

vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>")

require("nvim-tree").setup()
