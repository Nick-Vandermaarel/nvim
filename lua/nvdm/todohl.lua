-- Custom Highlight TODO, HACK, and NOTE comments

local M = {}
function M.setup()
    local group = vim.api.nvim_create_augroup('TodoHighlights', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'InsertLeave', 'ColorScheme' }, {
        group = group,
        pattern = '*',
        callback = function()
            vim.api.nvim_set_hl(0, 'TodoComment', { bg = '#50fa7b', fg = '#000000', bold = true })
            vim.api.nvim_set_hl(0, 'HackComment', { bg = '#ffb86c', fg = '#000000', bold = true })
            vim.api.nvim_set_hl(0, 'NoteComment', { bg = '#8be9fd', fg = '#000000', bold = true })

            vim.fn.clearmatches()
            -- Only match after comment characters
            vim.fn.matchadd('TodoComment', '\\(//\\|#\\|--\\|/\\*\\|<!--\\).*\\zs\\c\\<TODO\\>:\\?')
            vim.fn.matchadd('HackComment', '\\(//\\|#\\|--\\|/\\*\\|<!--\\).*\\zs\\c\\<HACK\\>:\\?')
            vim.fn.matchadd('NoteComment', '\\(//\\|#\\|--\\|/\\*\\|<!--\\).*\\zs\\c\\<NOTE\\>:\\?')
        end
    })
end

return M
