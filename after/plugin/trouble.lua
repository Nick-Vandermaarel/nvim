local trouble = require("trouble")

vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end, { desc = "Toggle trouble" })
vim.keymap.set("n", "<leader>xw", function() trouble.open("workspace_diagnostics") end,
    { desc = "Trouble workspace diagnostics" })
