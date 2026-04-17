vim.pack.add({
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("1.x"),
    },
})
require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
    },
    sources = {
        default = { "lsp", "snippets", "buffer", "path" },
        per_filetype = {
            c_sharp = { inherit_defaults = true, "easy-dotnet" },
        },
        providers = {
            ["easy-dotnet"] = {
                name = "easy-dotnet",
                enabled = true,
                module = "easy-dotnet.completion.blink",
                score_offset = 10000,
                async = true,
            },
            snippets = {
                -- Prevent snippets after a dot.
                should_show_items = function(ctx)
                    return ctx.trigger.initial_kind ~= "trigger_character"
                end,
            },
        },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            window = {
                border = "rounded",
            },
        },
        menu = {
            border = "rounded",
        },
    },
})
