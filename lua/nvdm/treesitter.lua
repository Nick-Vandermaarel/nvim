-- Note: Some languages require tree-sitter-cli to be installed on the system.
vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

local treesitter = require("nvim-treesitter")

local parsers = {
    "bash",
    "typescript",
    "vue",
    "html",
    "css",
    "json",
    "yaml",
    "dockerfile",
    "c_sharp",
    "lua",
    "vim",
    "markdown",
    "python",
    "sql",
    "odin",
}

treesitter.install(parsers)

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(args)
        if args.data.spec.name == "nvim-treesitter" and args.data.kind == "update" then
            treesitter.update()
        end
    end,
})

-- Enable Treesitter highlighting and indentation.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local filetype = args.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if lang ~= nil and vim.treesitter.language.add(lang) then
            vim.treesitter.start()

            if filetype ~= "cs" then
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            else
                vim.bo[args.buf].indentexpr = ""
                vim.cmd("setlocal cindent")
            end
        end
    end,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
    },
    move = {
        set_jumps = true,
    },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

local function map_select(lhs, query, desc)
    vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
    end, { desc = desc })
end

map_select("af", "@function.outer", "Select around function")
map_select("if", "@function.inner", "Select in function")
map_select("ac", "@class.outer", "Select around class")
map_select("ic", "@class.inner", "Select in class")
map_select("a=", "@assignment.outer", "Select outer part of assignment")
map_select("i=", "@assignment.inner", "Select inner part of assignment")
map_select("l=", "@assignment.lhs", "Select left-hand side of assignment")
map_select("r=", "@assignment.rhs", "Select right-hand side of assignment")
map_select("aa", "@parameter.outer", "Select outer parameter or argument")
map_select("ia", "@parameter.inner", "Select inner parameter or argument")
map_select("ai", "@conditional.outer", "Select outer conditional")
map_select("ii", "@conditional.inner", "Select inner conditional")
map_select("al", "@loop.outer", "Select outer loop")
map_select("il", "@loop.inner", "Select inner loop")

local function map_swap(lhs, operation, query, desc)
    vim.keymap.set("n", lhs, function()
        operation(query)
    end, { desc = desc })
end

map_swap("<leader>na", swap.swap_next, "@parameter.inner", "Swap parameter or argument with next")
map_swap("<leader>nm", swap.swap_next, "@function.outer", "Swap function with next")
map_swap("<leader>pa", swap.swap_previous, "@parameter.inner", "Swap parameter or argument with previous")
map_swap("<leader>pm", swap.swap_previous, "@function.outer", "Swap function with previous")

local function map_move(lhs, operation, query, desc)
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
        operation(query, "textobjects")
    end, { desc = desc })
end

local movements = {
    { suffix = "f", query = "@call.outer", description = "function call" },
    { suffix = "m", query = "@function.outer", description = "function definition" },
    { suffix = "c", query = "@class.outer", description = "class" },
    { suffix = "i", query = "@conditional.outer", description = "conditional" },
    { suffix = "l", query = "@loop.outer", description = "loop" },
    { suffix = "p", query = "@parameter.outer", description = "parameter or argument" },
}

for _, movement in ipairs(movements) do
    local suffix = movement.suffix
    local query = movement.query
    local description = movement.description

    map_move("]" .. suffix, move.goto_next_start, query, "Next " .. description .. " start")
    map_move("]" .. suffix:upper(), move.goto_next_end, query, "Next " .. description .. " end")
    map_move("[" .. suffix, move.goto_previous_start, query, "Previous " .. description .. " start")
    map_move("[" .. suffix:upper(), move.goto_previous_end, query, "Previous " .. description .. " end")
end

-- Keep Treesitter motions and the built-in f/F/t/T motions repeatable.
local repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T_expr, { expr = true })
