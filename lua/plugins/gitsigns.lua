return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    opts = {},
    config = function()
        require("gitsigns").setup()

        vim.keymap.set("n", "<leader>gp", ":Gitsignts preview_hunk<CR>", { desc = "Git Preview" });
        vim.keymap.set("n", "<leader>gt", ":Gitsignts toggle_current_line_blame<CR>",
            { desc = "Git Toggle Current Line Blame" });
    end
}
