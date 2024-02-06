require("ibl").setup {
    indent = {  char = "▏" },
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
