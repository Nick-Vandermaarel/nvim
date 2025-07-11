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
        opts = {},
        config = function()
            require("mini.surround").setup({
                -- Allows for tag replacements while keeping the inner content (attributes)
                custom_surroundings = {
                    T = {
                        input = { '<(%w+)[^<>]->.-</%1>', '^<()%w+().*</()%w+()>$' },
                        output = function()
                            local tag_name = MiniSurround.user_input('Tag name')
                            if tag_name == nil then return nil end
                            return { left = tag_name, right = tag_name }
                        end,
                    },
                },
            })
        end
    },
    {
        'echasnovski/mini.pairs',
        version = false,
        event = "InsertEnter",
        opts = {}
    },
}
