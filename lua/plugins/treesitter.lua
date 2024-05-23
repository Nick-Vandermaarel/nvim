return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require 'nvim-treesitter.configs'.setup {
                -- A list of parser names, or "all" (the five listed parsers should always be installed)
                ensure_installed = { "javascript", "typescript", "c_sharp", "vue", "python", "c", "lua", "vim", "vimdoc", "html", "http", "css", "scss", "markdown", "markdown_inline", "comment" },
                ignore_install = {}, -- List of parsers to ignore installing

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                autotag = {
                    enable = true,
                },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        --init_selection = "v",
                        node_incremental = "v",
                        scope_incremental = false,
                        node_decremental = "V",
                    },
                },
            }
        end,
    },
}
