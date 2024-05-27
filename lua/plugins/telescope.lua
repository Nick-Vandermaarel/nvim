return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim',
            "nvim-telescope/telescope-project.nvim",
        },
        event = "VeryLazy",
        config = function()
            require("telescope").load_extension("project")

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
            vim.keymap.set("n", "<leader>pp", require("telescope").extensions.project.project)
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") });
            end)
        end,
    },
}
