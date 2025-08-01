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

-- Get the foreground color from the devicon highlight group
_G.get_file_icon_color = function()
    local hl_name = _G.get_file_icon_hl()
    local hl = vim.api.nvim_get_hl(0, { name = hl_name })
    return hl.fg or ''
end

-- Then set MyFileIcon with the dynamic color
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'BufReadPost' }, {
    callback = function()
        local color = _G.get_file_icon_color()
        vim.api.nvim_set_hl(0, 'MyFileIcon', { fg = color })
    end
})

-- Use separate expressions for highlight and icon
vim.opt.winbar = '%#MyFileIcon#%{v:lua.get_file_icon()} %#WinBar#%t%r%#MyModified#%{&modified ? " ●" : " "}'
vim.api.nvim_set_hl(0, 'MyModified', { fg = '#ff9800' })

-- Create autocmd group
local group = vim.api.nvim_create_augroup('TodoHighlights', { clear = true })

-- Apply highlights
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'TextChanged', 'InsertLeave', 'ColorScheme' }, {
    group = group,
    pattern = '*',
    callback = function()
        -- Re-define highlights (in case colorscheme changed them)
        vim.api.nvim_set_hl(0, 'TodoComment', { bg = '#50fa7b', fg = '#000000', bold = true })
        vim.api.nvim_set_hl(0, 'HackComment', { bg = '#ffb86c', fg = '#000000', bold = true })
        vim.api.nvim_set_hl(0, 'NoteComment', { bg = '#8be9fd', fg = '#000000', bold = true })

        vim.fn.clearmatches()
        vim.fn.matchadd('TodoComment', '\\c\\<TODO\\>:\\?')
        vim.fn.matchadd('HackComment', '\\c\\<HACK\\>:\\?')
        vim.fn.matchadd('NoteComment', '\\c\\<NOTE\\>:\\?')
    end
})

-- disable unused plugins
for _, plugin in pairs({
    "netrwFileHandlers",
    "2html_plugin",
    "spellfile_plugin",
    "matchit"
}) do
    vim.g["loaded_" .. plugin] = 1
end


require("nvdm.autocmd")
require("nvdm.remap")
require("nvdm.set")
