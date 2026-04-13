vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

-- Treesitter
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

require("vim._core.ui2").enable({})

-- Settings
require("nvdm.autocmd")
require("nvdm.remap")
require("nvdm.set")

vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    "https://github.com/romamihalich/neogen",
    "https://github.com/lewis6991/gitsigns.nvim",
})

require("nvdm.winbar").setup()
require("nvdm.todohl").setup()

-- LSP
require("mason").setup({
    registries = {
        "github:Crashdummyy/mason-registry",
        "github:mason-org/mason-registry",
    },
})
require("mason-lspconfig").setup({
    automatic_enable = true,
})
-- require("nvim-lspconfig").setup({
--     diagnostics = { virtual_text = false },
-- })

-- color theme
require("kanagawa").setup({
    keywordStyle = { italic = false },
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none",
                },
            },
        },
    },
    overrides = function(colors)
        local theme = colors.theme
        local makeDiagnosticColor = function(color)
            local c = require("kanagawa.lib.color")
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
        end

        return {
            -- Right-click menu (Pmenu) - darker version
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            BlinkCmpMenuBorder = { fg = "", bg = "" },

            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

            DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
            DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
            DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
            DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

            -- Private cs fields
            ["@lsp.type.field.cs"] = { fg = colors.palette.fg },
            ["@lsp.type.constant.cs"] = { fg = colors.palette.dragonOrange2 },
        }
    end,
})
vim.cmd("colorscheme kanagawa-dragon")

-- undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require("undotree").open)

-- inline diagnostics
require("tiny-inline-diagnostic").setup({
    preset = "powerline",
    options = {
        multiline = true,
        virt_texts = {
            priority = 9000,
        },
    },
})
vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics

-- code doc generation
require("neogen").setup({
    enabled = true,
    languages = {
        cs = {
            template = {
                annotation_convention = "xmldoc",
            },
        },
    },
})
vim.keymap.set("n", "<leader>ng", require("neogen").generate, { desc = "Neogen comment" })

-- Git signs
require("gitsigns").setup({
    diff_opts = {
        ignore_whitespace = true,
    },
})
-- Auto-refresh gitsigns after git commit
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            require("gitsigns").refresh()
        end, 100)
    end,
    desc = "Refresh gitsigns after commit",
})
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Git Preview" })
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Git Toggle Current Line Blame" })
