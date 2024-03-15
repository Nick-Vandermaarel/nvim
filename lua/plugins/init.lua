-- PLUGINS FOR LAZY

return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    "nvim-telescope/telescope-project.nvim",
    "rebelot/kanagawa.nvim", -- Theme
    'numToStr/Comment.nvim',
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    {
        "nvim-lua/plenary.nvim",
        name = "plenary",
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { { "nvim-lua/plenary.nvim" } }
    },
    "mbbill/undotree",
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },

    "folke/neodev.nvim",
    "folke/neoconf.nvim",

    -- LSP
    { 'neovim/nvim-lspconfig' },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",           -- source for text in buffer
            "hrsh7th/cmp-path",             -- source for file system paths
            "L3MON4D3/LuaSnip",             -- snippet engine
            "saadparwaiz1/cmp_luasnip",     -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets
            "onsails/lspkind.nvim",         -- vs-code like pictograms
        },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim'
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = true,
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("nvim-autopairs").setup {} end
    },
    "windwp/nvim-ts-autotag",
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    "f-person/git-blame.nvim",
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup()
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },
    {
        "zbirenbaum/copilot.lua",
        cnd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false }
            })
        end
    },

    -- formatter
    {
        'stevearc/conform.nvim',
        lazy = true,
    },

    -- Documentation Generation
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
        event = "VeryLazy",
    },
    "norcalli/nvim-colorizer.lua",
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
    }
}
