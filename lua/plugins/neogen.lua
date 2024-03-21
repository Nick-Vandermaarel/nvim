return {
    -- Documentation Generation
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
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
                }
            }
        end,
    },
}
