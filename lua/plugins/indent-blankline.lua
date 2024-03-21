return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        main = "ibl",
        config = function()
            require("ibl").setup {
                indent = { char = "▏" },
                scope = {
                    enabled = true,
                    char = "▎",
                },
                exclude = {
                    filetypes = {
                        "help",
                        "dashboard",
                        "NVimtree",
                        "lsp-installer"
                    },
                    buftypes = { "terminal" },
                },
            }
        end,
    },
}
