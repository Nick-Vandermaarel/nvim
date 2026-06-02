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
require("nvdm.remap")
require("nvdm.set")
require("nvdm.diagnostic")

vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/seblyng/roslyn.nvim",
    "https://github.com/folke/lazydev.nvim",

    -- Note: Some languages require the tree-sitter-cli installed to the OS
    "https://github.com/nvim-treesitter/nvim-treesitter",

    -- Less important
    "https://github.com/sindrets/diffview.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/romamihalich/neogen",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    "https://github.com/windwp/nvim-ts-autotag",
    "https://github.com/nvim-mini/mini.pairs",
})

require("nvdm.winbar").setup()
require("nvdm.todohl").setup()
require("lazydev").setup()
require("nvim-ts-autotag").setup()
require("mini.pairs").setup()
require("diffview").setup()

---
-- Treesitter
local ts_parsers = {
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
}

local nts = require("nvim-treesitter")
nts.install(ts_parsers)
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function()
        nts.update()
    end,
})

-- Enable treesitter highlighting and indents
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local filetype = args.match
        local lang = vim.treesitter.language.get_lang(filetype)
        if lang ~= nil then
            if vim.treesitter.language.add(lang) then
                vim.treesitter.start()

                if filetype ~= "cs" then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                else
                    vim.bo[args.buf].indentexpr = ""
                    vim.cmd("setlocal cindent")
                end
            end
        end
    end,
})

------
-- LSP
require("mason").setup({
    registries = {
        -- "github:Crashdummyy/mason-registry",
        "github:mason-org/mason-registry",
    },
})
require("mason-lspconfig").setup({
    automatic_enable = true,
})
-- vim.lsp.codelens.enable(true)
local lspUtils = require("nvdm.lspUtils")
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(args)
        lspUtils.onAttach(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client ~= nil then
            vim.lsp.document_color.enable(true)

            -- Custom component highlighting for vue
            local existing_capabilities = client.server_capabilities
            if existing_capabilities and existing_capabilities.semanticTokensProvider then
                if vim.bo.filetype == "vue" then
                    existing_capabilities.semanticTokensProvider.full = false
                else
                    existing_capabilities.semanticTokensProvider.full = true
                end
            end

            -- Semantic highlighting when hovering
            if client.server_capabilities.documentHighlightProvider then
                local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. args.buf, { clear = true })

                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = group,
                    buffer = args.buf,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertLeave", "BufLeave" }, {
                    group = group,
                    buffer = args.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end
    end,
})

vim.lsp.inlay_hint.enable()

local vue_language_server_path = vim.fn.expand("$MASON/packages")
    .. "/vue-language-server"
    .. "/node_modules/@vue/language-server"
local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
    configNamespace = "typescript",
}
local ts_ls_config = {
    init_options = {
        plugins = {
            vue_plugin,
        },
    },
    filetypes = tsserver_filetypes,
}

local vue_ls_config = {}
vim.lsp.config("ts_ls", ts_ls_config)
vim.lsp.config("vue_ls", vue_ls_config)
vim.lsp.enable({ "ts_ls", "vue_ls" })

vim.lsp.config("cssls", {
    settings = {
        css = {
            validate = true,
            lint = {
                unknownAtRules = "ignore",
            },
        },
    },
})

vim.lsp.enable("roslyn_ls")
vim.lsp.config("roslyn_ls", {
    filetypes = { "razor", "cs", "sln", "slnx", "csproj" },

    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true, -- Run/debug tests inline
        },
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = false,
            csharp_enable_inlay_hints_for_implicit_variable_types = false,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = false,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = false,
            dotnet_enable_inlay_hints_for_object_creation_parameters = false,
            dotnet_enable_inlay_hints_for_other_parameters = false,
            dotnet_enable_inlay_hints_for_parameters = true,
        },
        ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
        },
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
        },
        ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
        },
    },
})

-- Color theme
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

-- Session persistence
vim.pack.add({ "https://github.com/folke/persistence.nvim" })
require("persistence").setup({
    dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
    options = { "buffers", "curdir", "tabpages", "winsize" },
})
vim.keymap.set("n", "<leader>rl", function()
    require("persistence").load()
end, { desc = "Reload last session" })

-- Yank highlight
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})
