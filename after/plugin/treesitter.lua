require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "javascript", "typescript", "c_sharp", "vue", "python", "c", "lua", "vim", "vimdoc", "query", "html", "http" },

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
            init_selection = "<leader><tab>",
            node_incremental = "<leader><tab>",
            scope_incremental = "<leader>.",
            node_decremental = "<S-tab>",
        },
    },
    move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
        },
        goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
        },
        goto_previous_start = {
            ["[m"] = "@function.outer",
            ["]["] = "@class.outer",
        },
        goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
        },
    },
    swap = {
        enable = true,
        swap_next = {
            ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
            ["<leader>A"] = "@parameter.outer",
        }
    }
}
