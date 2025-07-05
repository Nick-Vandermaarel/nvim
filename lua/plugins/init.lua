-- PLUGINS FOR LAZY
local rm = require("nvdm.remap");
return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },
    {
        "mbbill/undotree",
        event = "VeryLazy",
        config = function()
            rm.Map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo tree" });
        end
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
        "windwp/nvim-ts-autotag",
        event = "BufReadPre",
        opts = {}
    },
    {
        'echasnovski/mini.surround',
        version = false,
        opts = {}
    },
    {
        'echasnovski/mini.pairs',
        version = false,
        event = "InsertEnter",
        opts = {}
    },
}
