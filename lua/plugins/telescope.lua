return {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    opts = {
        defaults = {
            path_display = {
                "filename_first"
            }
        }
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
        vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Telescope live grep" })
        -- vim.keymap.set('n', '<leader>ps', function()
        --     builtin.grep_string({ search = vim.fn.input("Grep > ") });
        -- end)
    end,
}
