-- PLUGINS FOR LAZY

return {
  {
	  'nvim-telescope/telescope.nvim', tag = '0.1.5',
	  -- or                            , branch = '0.1.x',
	  dependencies = { {'nvim-lua/plenary.nvim'} }
  },

  'navarasu/onedark.nvim', -- Theme

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
  {
    "mbbill/undotree",
    lazy = true,
  },
  {
    "tpope/vim-fugitive",
    lazy = true,
  },

  {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  dependencies = {
		  --- Uncomment these if you want to manage LSP servers from neovim
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'L3MON4D3/LuaSnip'},
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
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
    end
  },

    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",

    {
	    "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        config = function() require("ibl").setup {} end
    },

    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup()
        end,
        dependencies = {{'nvim-tree/nvim-web-devicons'}}
    },
}
