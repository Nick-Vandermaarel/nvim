-- PLUGINS FOR LAZY

return {
  {
	  'nvim-telescope/telescope.nvim', tag = '0.1.5',
	  -- or                            , branch = '0.1.x',
	  dependencies = { {'nvim-lua/plenary.nvim'} }
  },
    "nvim-telescope/telescope-project.nvim",
    "rebelot/kanagawa.nvim",
  'numToStr/Comment.nvim',
  'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
  {
    'nvim-treesitter/playground',
  },
  "nvim-lua/plenary.nvim", -- don't forget to add this one if you don't have it yet!
  {
	  "ThePrimeagen/harpoon",
	  branch = "harpoon2",
	  dependencies = { {"nvim-lua/plenary.nvim"} }
  },
    "mbbill/undotree",
    "tpope/vim-fugitive",

    -- LSP
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},

  {
      "lewis6991/gitsigns.nvim",
      dependencies = {
          "nvim-lua/plenary.nvim"
      }
  },

    {
        "folke/which-key.nvim",
        event ="VeryLazy",
        init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
            end,
        opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        }
    },

    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",
    {
	    "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    },
    "windwp/nvim-ts-autotag",
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function() require("ibl").setup {} end
    },
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
        dependencies = {{'nvim-tree/nvim-web-devicons'}}
    },
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    "github/copilot.vim",
}
