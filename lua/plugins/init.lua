-- PLUGINS FOR LAZY
return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },
    {
        "mbbill/undotree",
        config = true,
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo tree" } },
        },
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            require("persistence").setup({
                dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
                options = { "buffers", "curdir", "winsize" },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = "BufReadPre",
        opts = {},
    },
    {
        "nvim-mini/mini.surround",
        version = false,
        event = "VeryLazy",
        opts = {},
        config = function()
            require("mini.surround").setup({
                -- Allows for tag replacements while keeping the inner content (attributes)
                custom_surroundings = {
                    T = {
                        input = { "<(%w+)[^<>]->.-</%1>", "^<()%w+().*</()%w+()>$" },
                        output = function()
                            local tag_name = MiniSurround.user_input("Tag name")
                            if tag_name == nil then
                                return nil
                            end
                            return { left = tag_name, right = tag_name }
                        end,
                    },
                },
                n_lines = 100,
            })
        end,
    },
    {
        "nvim-mini/mini.pairs",
        version = false,
        event = "InsertEnter",
        opts = {},
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
    {
        "sindrets/diffview.nvim",
        opts = {},
    },
}
