local group = vim.api.nvim_create_augroup("LazyLoadEasyDotnet", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
    callback = function()
        vim.api.nvim_del_augroup_by_name("LazyLoadEasyDotnet")

        vim.pack.add({
            "https://github.com/GustavEikaas/easy-dotnet.nvim",
            "https://github.com/nvim-lua/plenary.nvim",
        })

        require("easy-dotnet").setup({
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
    end,
})
