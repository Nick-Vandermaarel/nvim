return {
    "nvim-treesitter/nvim-treesitter-refactor",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('nvim-treesitter.configs').setup {
            refactor = {
                highlight_definitions = {
                    enable = true,
                    clear_on_cursor_move = true,
                },
                navigation = {
                    enable = true,
                    keymaps = {
                        goto_definition = "gnd",
                        list_definitions = "gnD",
                        list_definitions_toc = "gO",
                        goto_next_usage = "<a-*>",
                        goto_previous_usage = "<a-#>",
                    }
                }
            }
        }
    end
}
