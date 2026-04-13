return {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'folke/snacks.nvim', },
    ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
    lazy = true,
    cmd = "Dotnet",
    config = function()
        local dotnet = require("easy-dotnet")
        dotnet.setup({
            lsp = {
                enabled = false,
            },
            test_runner = {
                viewmode = "float",
                enable_buffer_text_execution = true, -- experimental
                icons = {
                    passed = "",
                    skipped = "",
                    failed = "",
                    success = "",
                    reload = "",
                    test = "",
                    sln = "󰘐",
                    project = "󰘐",
                    dir = "",
                    package = "",
                },
            },
            auto_bootstrap_namespace = {
                type = "file_scoped",
                enabled = true,
            },
            picker = "snacks",
        })

        vim.keymap.set("n", "<C-b>", function()
            dotnet.testrunner_refresh_build()
        end)
    end
}
