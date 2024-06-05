return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require("nvim-tree").setup({
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    adaptive_size = true,
                    relativenumber = true
                },
            })

            vim.keymap.set("n", "<leader>]", ":NvimTreeToggle<CR>")
            vim.keymap.set("n", "<leader>'", ":NvimTreeFocus<CR>")
        end,
        keys = {
            {
                "<leader>]",
            }
        }
    },
}
