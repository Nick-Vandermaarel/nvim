function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

Map("n", "<leader>w", ":w!<CR>")
Map("n", "<leader>q", ":q!<CR>")
Map("n", "<leader>x", ":x!<CR>")
Map("n", "<leader>bd", ":bd<CR>")

Map("v", "J", ":m '>+1<CR>gv=gv")
Map("v", "K", ":m '<-2<CR>gv=gv")

Map("n", "<C-d>", "<C-d>zz")
Map("n", "<C-u>", "<C-u>zz")
Map("n", "n", "nzzzv")
Map("n", "N", "Nzzzv")

Map("x", "<leader>p", "\"_dp")

-- Copy to system keyboard
Map("n", "<leader>y", "\"+y")
Map("v", "<leader>y", "\"+y")
Map("n", "<leader>Y", "\"+Y")

-- Replace line i'm currently on
Map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Buffer navigation
Map("n", "]b", "<cmd>bn<cr>")
Map("n", "[b", "<cmd>bp<cr>")

-- Movement
Map("n", "<C-h>", "<C-w>h")
Map("n", "<C-j>", "<C-w>j")
Map("n", "<C-k>", "<C-w>k")
Map("n", "<C-l>", "<C-w>l")

-- Terminal, movement
Map("t", "<C-h>", "<cmd>wincmd h<CR>")
Map("t", "<C-j>", "<cmd>wincmd j<CR>")
Map("t", "<C-k>", "<cmd>wincmd k<CR>")
Map("t", "<C-l>", "<cmd>wincmd l<CR>")

-- Resizing
Map("n", "<C-Up>", ":resize -2<CR>")
Map("n", "<C-Down>", ":resize +2<CR>")
Map("n", "<C-Left>", ":vertical resize -2<CR>")
Map("n", "<C-Right>", ":vertical resize +2<CR>")

-- terminal
Map("t", "<C-Up>", "<cmd>resize -2<CR>")
Map("t", "<C-Down>", "<cmd>resize +2<CR>")
Map("t", "<C-Left>", "<cmd>vertical resize -2<CR>")
Map("t", "<C-Right>", "<cmd>vertical resize +2<CR>")
Map("t", "<esc>", "<C-\\><C-n>")
Map("n", "<C-\\>", "<cmd>ToggleTerm<CR>")
Map("n", "2<C-\\>", "<cmd>2ToggleTerm<CR>")

-- Neogen Documentation
Map("n", "<leader>d", "<cmd>lua require('neogen').generate()<CR>")
Map("n", "<leader>dc", "<cmd>lua require('neogen').generate({ type = 'class'})<CR>")

-- Create a new Tab.
Map("n", "<C-t>", "<cmd>:tabnew<CR>", { desc = 'New Tab' });

-- Splits
Map("n", "<C-x>", "<cmd>split<CR>", { desc = "Horizontal Split" });
Map("n", "<C-v>", "<cmd>vsplit<CR>", { desc = "Vertical Split" });
