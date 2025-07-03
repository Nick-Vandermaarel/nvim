return {
    'saghen/blink.cmp',
    event = "InsertEnter",
    dependencies = 'rafamadriz/friendly-snippets',
    version = "*",
    opts = {
        keymap = { preset = 'default' },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { 'lsp', 'snippets', 'buffer', 'path' },
            providers = {
                ['easy-dotnet'] = {
                    name = "easy-dotnet",
                    enabled = true,
                    module = "easy-dotnet.completion.blink",
                    score_offset = 1000,
                    async = true,
                }
            }
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
                border = "rounded",
            },
        },
    }
}
