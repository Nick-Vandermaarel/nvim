local M = {}
M.Map = function(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

M.Map("n", "<leader>w", ":w!<CR>")
M.Map("n", "<leader>q", ":q!<CR>")
M.Map("n", "<leader>x", ":x!<CR>")

M.Map("v", "J", ":m '>+1<CR>gv=gv")
M.Map("v", "K", ":m '<-2<CR>gv=gv")

-- Indents
M.Map("v", "<", "<gv")
M.Map("v", ">", ">gv")

M.Map("n", "<C-d>", "<C-d>zz")
M.Map("n", "<C-u>", "<C-u>zz")
M.Map("n", "n", "nzzzv")
M.Map("n", "N", "Nzzzv")

M.Map("x", "<leader>p", '"_dp')

-- Copy to system keyboard
M.Map("n", "<leader>y", '"+y')
M.Map("v", "<leader>y", '"+y')
M.Map("n", "<leader>Y", '"+Y')

-- Buffer navigation
M.Map("n", "]b", "<cmd>bn<cr>", { desc = "Next Buffer" })
M.Map("n", "[b", "<cmd>bp<cr>", { desc = "Previous Buffer" })
M.Map("n", "db", "<cmd>bd<CR>", { desc = "Delete Buffer" })

-- Movement
M.Map({ "n", "t" }, "<C-h>", "<C-w>h")
M.Map({ "n", "t" }, "<C-j>", "<C-w>j")
M.Map({ "n", "t" }, "<C-k>", "<C-w>k")
M.Map({ "n", "t" }, "<C-l>", "<C-w>l")

-- Resizing
M.Map("n", "<C-Up>", ":resize -2<CR>")
M.Map("n", "<C-Down>", ":resize +2<CR>")
M.Map("n", "<C-Left>", ":vertical resize -2<CR>")
M.Map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Splits
M.Map("n", "<C-x>", "<cmd>split<CR>", { desc = "Horizontal Split" })
M.Map("n", "<C-v>", "<cmd>vsplit<CR>", { desc = "Vertical Split" })

M.Map("n", "<leader>v", "<C-v>", { desc = "Visual Block" })
M.Map("v", "<leader>r", ":s/\\%V", { desc = "Find and replace visual mode" })

vim.keymap.set({ "n", "x", "o" }, "<CR>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_parent(vim.v.count1)
    else
        vim.lsp.buf.selection_range(vim.v.count1)
    end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "n", "x", "o" }, "<BS>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_child(vim.v.count1)
    else
        vim.lsp.buf.selection_range(-vim.v.count1)
    end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

return M
