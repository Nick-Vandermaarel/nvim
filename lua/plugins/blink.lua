return {
    'saghen/blink.cmp',
    event = "InsertEnter",
    -- optional snippets
    dependencies = 'rafamadriz/friendly-snippets',
    version = "*",
    opts = {
        keymap = { preset = 'super-tab' },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { 'lsp', 'snippets', 'buffer', 'path' },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = { enabled = true },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                window = {
                    border = "rounded"
                }
            },
            menu = {
                border = "rounded"
            },
        },
    },
    opts_extend = { "sources.default" }
}
