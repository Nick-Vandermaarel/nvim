return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    config = function()
        require("gitsigns").setup({
            diff_opts = {
                ignore_whitespace = true,
            },
        })

        -- -- Auto-refresh gitsigns after git commit
        -- vim.api.nvim_create_autocmd("BufWritePost", {
        --     pattern = "COMMIT_EDITMSG",
        --     callback = function()
        --         vim.defer_fn(function()
        --             require("gitsigns").refresh()
        --         end, 100)
        --     end,
        --     desc = "Refresh gitsigns after commit",
        -- })

        vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Git Preview" })
        vim.keymap.set(
            "n",
            "<leader>gt",
            ":Gitsigns toggle_current_line_blame<CR>",
            { desc = "Git Toggle Current Line Blame" }
        )
    end,
}
