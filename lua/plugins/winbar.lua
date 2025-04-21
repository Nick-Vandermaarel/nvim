return {
    "ramilito/winbar.nvim",
    event = "BufReadPre", -- Alternatively, BufReadPre if we don't care about the empty file when starting with 'nvim'
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("winbar").setup({
            icons = true,
            diagnostics = true,
            buf_modified = true,
            buf_modified_symbol = "●",
            dim_inactive = {
                enabled = false,
                highlight = "WinBarNC",
                icons = true, -- whether to dim the icons
                name = true,  -- whether to dim the name
            }
        })
    end
}
