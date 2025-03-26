return {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'folke/snacks.nvim', },
    event = "VeryLazy",
    config = function()
        require("easy-dotnet").setup({
            test_runner = {
                viewmode = "split",
                enable_buffer_test_execution = true, -- experimental
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
    end
}
