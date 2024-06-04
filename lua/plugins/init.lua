-- PLUGINS FOR LAZY

return {
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
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {}
    },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        event = "VeryLazy",
        opts = {}
    }
}
