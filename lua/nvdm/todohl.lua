-- Custom Highlight TODO, HACK, and NOTE comments

local M = {}

function M.setup()
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
end

return M
