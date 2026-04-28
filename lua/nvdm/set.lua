local o = vim.opt

o.nu = true
o.relativenumber = true
o.cursorline = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.autoindent = true
o.breakindent = true
o.smartindent = true

o.wrap = false

o.swapfile = false
o.backup = false
o.undofile = true

o.ignorecase = true
o.smartcase = true
o.hlsearch = false

o.incsearch = true

o.termguicolors = true

o.scrolloff = 8
o.updatetime = 50

o.colorcolumn = "120"

o.title = true
o.titlestring = [[%t - %{fnamemodify(getcwd(), ':t')}]]

vim.api.nvim_command("aunmenu PopUp.How-to\\ disable\\ mouse")
vim.api.nvim_command("aunmenu PopUp.-1-")

-- Sync clipboard between OS and Neovim
o.clipboard = "unnamedplus"

o.listchars = {
    space = "⋅",
}
o.list = true

-- Sign column always visible for LSP/Git markers.
o.signcolumn = "yes"
o.winborder = "rounded"
