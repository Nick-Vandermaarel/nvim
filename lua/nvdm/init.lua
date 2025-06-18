local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Leader must be setup first so lazy can bind correctly.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazy").setup("plugins")

-- Function to get just the icon
_G.get_file_icon = function()
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    local icon, _ = require('nvim-web-devicons').get_icon(filename, extension)
    return icon or ''
end

-- Function to get the highlight group name
_G.get_file_icon_hl = function()
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    local _, hl_name = require('nvim-web-devicons').get_icon(filename, extension)
    return hl_name or 'WinBar'
end

-- Use separate expressions for highlight and icon
vim.opt.winbar =
'%#MyModified#%{&modified ? "● " : "  "}%{%"%#" . v:lua.get_file_icon_hl() . "#"%}%{v:lua.get_file_icon()} %#WinBar#%t'
vim.api.nvim_set_hl(0, 'MyModified', { fg = '#ff6b6b' })

require("nvdm.autocmd")
require("nvdm.remap")
require("nvdm.set")
