return {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'folke/snacks.nvim', },
    event = "VeryLazy",
    config = function()
        require("easy-dotnet").setup({
            test_runner = {
                viewmode = "split",
                enable_buffer_test_execution = true, -- experimental
            },
            auto_bootstrap_namespace = {
                type = "file_scoped",
                enabled = true,
            },
            picker = "snacks",
        })
    end
}
