return {
    'b0o/incline.nvim',
    config = function()
        local helpers = require "incline.helpers"
        local devicons = require 'nvim-web-devicons'
        local colors = require("kanagawa.colors").setup()
        require('incline').setup {
            window = {
                padding = 0,
                margin = { horizontal = 0 },
            },
            hide = {
                cursorline = true,
            },
            highlight = {
                groups = {
                    InclineNormal = { guibg = "#8b008b", guifg = "#FFFFFF" },
                    InclineNormalNC = { guifg = colors.theme.ui.fg, guibg = colors.theme.ui.bg_m1 },
                }
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                if filename == '' then
                    filename = '[No Name]'
                end
                if vim.bo[props.buf].modified then
                    filename = "[+]" .. filename
                end

                local ft_icon, ft_color = devicons.get_icon_color(filename)

                return {
                    {
                        ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or
                        '',
                    },
                    { " " },
                    { filename },
                    { " " }
                }
            end,
        }
    end,
}
