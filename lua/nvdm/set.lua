--vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

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

-- If running on Windows, ensure the default shell is using Powershell.
if vim.fn.has("win32") then
    -- Check if 'pwsh' is executable and set the shell accordingly
    if vim.fn.executable('pwsh') == 1 then
        vim.o.shell = 'pwsh'
    else
        vim.o.shell = 'powershell'
    end

    -- Setting shell command flags
    vim.o.shellcmdflag =
    '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';'

    -- Setting shell redirection
    vim.o.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'

    -- Setting shell pipe
    vim.o.shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'

    -- Setting shell quote options
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end
