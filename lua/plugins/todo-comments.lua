return {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local todo_comments = require("todo-comments");
        local keymap = vim.keymap;

        keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, { desc = "Next todo comment" })

        keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous todo comment" })

        keymap.set("n", "<leader>tt", ":TodoLocList<CR>", { desc = "Todo location list" })

        todo_comments.setup()
    end
}
