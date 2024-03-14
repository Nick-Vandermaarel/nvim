-- PLUGINS FOR LAZY

return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    "nvim-telescope/telescope-project.nvim",
    "rebelot/kanagawa.nvim", -- Theme
    {
        'numToStr/Comment.nvim',
        lazy = true,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    {
        'nvim-treesitter/playground',
    },
    "nvim-lua/plenary.nvim", -- don't forget to add this one if you don't have it yet!
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { { "nvim-lua/plenary.nvim" } }
    },
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "folke/neoconf.nvim",

    -- LSP
    { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        }
    },
    { "rafamadriz/friendly-snippets" },
    {
        'L3MON4D3/LuaSnip',
        depenedencies = {
            { 'rafamadriz/friendly-snippets' }
        }
    },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    {
        "nvim-tree/nvim-tree.lua",
        lazy = true,
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true
    },
    {
        "windwp/nvim-autopairs",
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
    "github/copilot.vim",

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
