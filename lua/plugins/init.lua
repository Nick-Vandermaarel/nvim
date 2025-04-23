-- PLUGINS FOR LAZY

return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },
    {
        'numToStr/Comment.nvim',
        event = "BufReadPre",
        opts = {}
    },
    {
        "mbbill/undotree",
        event = "VeryLazy",
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            require("persistence").setup {
                dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
                options = { "buffers", "curdir", "winsize" },
            }
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "windwp/nvim-ts-autotag",
        event = "BufReadPre",
        opts = {}
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {
            user_default_options = {
                RGB = false,
                names = false,
                RRGGBB = true,
                AARRGGBB = false,
            },
        },
    },
    {
        'echasnovski/mini.surround',
        version = false,
        opts = {}
    },
    { 'echasnovski/mini.pairs', version = false, opts = {} },
}
