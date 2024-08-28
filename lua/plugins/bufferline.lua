return {
    'akinsho/bufferline.nvim',
    event = "BufReadPre",
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        options = {
            diagnostics = "nvim_lsp"
        }
    }
}
