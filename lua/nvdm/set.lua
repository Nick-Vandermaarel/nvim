--vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 50

vim.opt.title = true
vim.opt.titlestring = [[%t - %{fnamemodify(getcwd(), ':t')}]]

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus"

vim.opt.listchars = {
    space = "⋅",
}
vim.opt.list = true

if vim.fn.has('win32') == 1 then
    vim.g.undotree_DiffCommand = "FC"

    -- Powershell core settings.
    vim.opt.shell = 'pwsh'
    vim.opt.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';'
    vim.opt.shellredir = '2>&1 | %%{ \\"$_\\" } | Out-File %s; exit $LastExitCode'
    vim.opt.shellpipe = '2>&1 | %%{ \\"$_\\" } | tee %s; exit $LastExitCode'
    vim.opt.shellquote = ''
    vim.opt.shellxquote = vim.fn.has('nvim') == 1 and '' or '"'
end
