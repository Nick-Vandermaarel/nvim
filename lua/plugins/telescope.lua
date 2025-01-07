return {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    dependencies = {
        'nvim-lua/plenary.nvim',
        "nvim-telescope/telescope-fzy-native.nvim"
    },
    opts = {
        defaults = {
            path_display = {
                "filename_first"
            }
        }
    },
    config = function()
        require("telescope").load_extension("fzy_native")

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
        vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Telescope live grep" })
        vim.keymap.set("n", "<leader>pt", builtin.lsp_dynamic_workspace_symbols,
            { desc = "Telescope Dynamic Workspace Symbols" })
    end,
}
