return {
    -- formatter
    'stevearc/conform.nvim',
    event = "BufReadPre",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                javascript = { "biome" },
                typescript = { "biome" },
                vue = { "biome" },
                scss = { "biome" },
                json = { "biome" },
                html = { "biome" },
                css = { "biome" },
                markdown = { "biome" },
                -- cs = { { "csharpier" } },
            },
            format_on_save = {
                async = false,
                timeout_ms = 5000,
                lsp_fallback = true,
            }
        })
    end,
}
