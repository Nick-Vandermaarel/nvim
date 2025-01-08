return
{
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
    config = function()
        require("easy-dotnet").setup({
            test_runner = {
                viewmode = "split",
                enable_buffer_test_execution = true,
            },
        })
    end
}
