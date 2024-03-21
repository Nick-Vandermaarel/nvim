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
                    adaptive_size = true
                },
            })

            -- Disable netrw
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

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
