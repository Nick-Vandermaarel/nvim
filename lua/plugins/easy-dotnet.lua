return {
    "GustavEikaas/easy-dotnet.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", 'folke/snacks.nvim', },
    config = function()
        local dotnet = require("easy-dotnet")
        dotnet.setup({
            test_runner = {
                viewmode = "buf",
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
