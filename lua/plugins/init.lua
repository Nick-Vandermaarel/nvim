-- PLUGINS FOR LAZY

return {
    {
        "tpope/vim-fugitive"
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
                options = { "buffers", "curdir", "tabpages", "winsize" },
            }
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {}
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
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
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
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        event = "VeryLazy",
        opts = {}
    },
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
            })

            vim.keymap.set("n", "<leader>]", ":NvimTreeToggle<CR>")
            vim.keymap.set("n", "<leader>'", ":NvimTreeFocus<CR>")
        end,
    }
}
