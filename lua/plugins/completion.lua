return {
    'saghen/blink.cmp',
    event = "VeryLazy",
    dependencies = 'rafamadriz/friendly-snippets',
    version = "*",
    opts = {
        keymap = { preset = 'super-tab' },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = { enabled = true },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                treesitter_highlighting = true,
                window = {
                    border = "rounded"
                },
            },
            menu = {
                border = "none",
            },
        },
    },
    opts_extend = { "sources.default" }
}
