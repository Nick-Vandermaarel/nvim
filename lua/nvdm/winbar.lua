-- Custom winbar. File icon + color, and modified indicator.

local M = {}

-- Function to get just the icon
local function get_file_icon()
    local filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
    local icon, _ = require("nvim-web-devicons").get_icon(filename, extension)
    return icon or ""
end

-- Function to get the highlight group name
local function get_file_icon_hl()
    local filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
    local _, hl_name = require("nvim-web-devicons").get_icon(filename, extension)
    return hl_name or "WinBar"
end

function M.setup()
    _G.get_file_icon = get_file_icon
    _G.get_file_icon_hl = get_file_icon_hl

    vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
        callback = function()
            local filename = vim.fn.expand("%:t")
            local extension = vim.fn.expand("%:e")
            local _, hl_name = require("nvim-web-devicons").get_icon(filename, extension)

            if hl_name then
                vim.wo.winhighlight = "MyFileIcon:" .. hl_name
            end
        end,
    })

    vim.opt.winbar = '%#MyFileIcon#%{v:lua.get_file_icon()} %#WinBar#%t%r%#MyModified#%{&modified ? " ●" : " "}'
    vim.api.nvim_set_hl(0, "MyModified", { fg = "#ff9800" })
end

return M
