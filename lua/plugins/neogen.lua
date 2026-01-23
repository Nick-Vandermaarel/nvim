-- romamihalich/neogen

return {
    "romamihalich/neogen", -- include some c# fixes.
    keys = {
        { "<leader>ng", "<cmd>lua require('neogen').generate()<CR>", desc = "Neogen comment", mode = "n" },
    },
    config = function()
        require("neogen").setup({
            enabled = true,
            languages = {
                cs = {
                    template = {
                        annotation_convention = "xmldoc",
                    },
                },
            },
        })
    end,
}
