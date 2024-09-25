return
{
    "nvim-tree/nvim-tree.lua",
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    event = "VeryLazy",
    config = function()
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                adaptive_size = true,
                relativenumber = true
            },
            update_focused_file = {
                enable = true
            }
        })

        vim.keymap.set("n", "<leader>]", ":NvimTreeToggle<CR>")
        vim.keymap.set("n", "<leader>'", ":NvimTreeFindFile<CR>")
    end,
}
