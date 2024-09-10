---@diagnostic disable: missing-fields
return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require('nvim-treesitter.configs').setup {
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "Select around function" },
                        ["if"] = { query = "@function.inner", desc = "Select in function" },
                        ["ac"] = { query = "@class.outer", desc = "Select around class" },
                        ["ic"] = { query = "@class.inner", desc = "Select in class" },

                        -- assignment
                        ["a="] = { query = "@assignment.outer", desc = "Select outer part of assignment" },
                        ["i="] = { query = "@assignment.inner", desc = "Select inner part of assignment" },
                        ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                        ["r="] = { query = "@assignment.rhs", desc = "Select right hande side of an assignment" },

                        -- parameter
                        ["aa"] = { query = "@parameter.outer", desc = "Select outer of a parameter/argument" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inner of a parameter/argument" },

                        -- conditional
                        ["ai"] = { query = "@conditional.outer", desc = "Select outer of a conditional" },
                        ["ii"] = { query = "@conditional.inner", desc = "Select inner of a conditional" },

                        -- loop
                        ["al"] = { query = "@loop.outer", desc = "Select outer of a loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inner of a loop" },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
                        ["<leader>nm"] = "@function.outer",  -- swap function with next
                    },
                    swap_previous = {
                        ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with previous
                        ["<leader>pm"] = "@function.outer",  -- swap function with previous
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = { query = "@call.outer", desc = "Next function call start" },
                        ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
                        ["]c"] = { query = "@class.outer", desc = "Next class start" },
                        ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                        ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
                        ["]p"] = { query = "@parameter.outer", desc = "Next parameter/argument start" },
                    },
                    goto_next_end = {
                        ["]F"] = { query = "@call.outer", desc = "Next function call end" },
                        ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
                        ["]C"] = { query = "@class.outer", desc = "Next class end" },
                        ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                        ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                        ["]P"] = { query = "@parameter.outer", desc = "Next parameter/argument end" },

                    },
                    goto_previous_start = {
                        ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
                        ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
                        ["[c"] = { query = "@class.outer", desc = "Prev class start" },
                        ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
                        ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
                        ["[p"] = { query = "@parameter.outer", desc = "Prev parameter/argument start" },
                    },
                    goto_previous_end = {
                        ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
                        ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
                        ["[C"] = { query = "@class.outer", desc = "Prev class end" },
                        ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
                        ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
                        ["[P"] = { query = "@parameter.outer", desc = "Prev parameter/argument" },
                    },
                },
            },
        }

        -- Repeatable motions
        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

        vim.keymap.set({ "x", "x", "o" }, ";", ts_repeat_move.repeat_last_move);
        vim.keymap.set({ "x", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite);

        vim.keymap.set({ "x", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true });
        vim.keymap.set({ "x", "x", "o" }, "F", ts_repeat_move.builtin_f_expr, { expr = true });
        vim.keymap.set({ "x", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true });
        vim.keymap.set({ "x", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
}
