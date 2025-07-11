return {
    -- "danymat/neogen",
    "nick-vandermaarel/neogen",
    branch = "cs-records",

    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    config = function()
        require("neogen").setup {
            enabled = true,
            input_after_comment = true,
            languages = {
                cs = {
                    template = {
                        annotation_convention = "xmldoc",
                    }
                }
            },
        }
        local rm = require("nvdm.remap");
        rm.Map("n", "<leader>dm", "<cmd>lua require('neogen').generate()<CR>", { desc = "Document method" })
        rm.Map("n", "<leader>dc", "<cmd>lua require('neogen').generate({ type = 'class'})<CR>",
            { desc = "Document class" })
    end,
}
