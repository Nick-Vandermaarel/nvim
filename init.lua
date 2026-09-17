vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

require("vim._core.ui2").enable({})

-- Settings
require("nvdm.remap")
require("nvdm.set")
require("nvdm.diagnostic")

vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/seblyng/roslyn.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/folke/persistence.nvim",

    -- Less important
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

require("nvdm.treesitter")

------
-- LSP
require("mason").setup({
    registries = {
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

-- setup using roslyn nvim
vim.lsp.config("roslyn_ls", {
    filetypes = { "razor", "cs", "sln", "slnx", "csproj" },

    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
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
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    signs_staged = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    diff_opts = {
        ignore_whitespace = true,
    },
})
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Git Preview" })
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Git Toggle Current Line Blame" })

-- Session persistence
require("persistence").setup({
    dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
})
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
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

-- COLORS here for lualine to work nicely. Extra config is stored in the theme.lua if needed.
vim.pack.add({ "https://github.com/webhooked/kanso.nvim" })
require("kanso").setup({
    minimal = true,
    colors = {
        theme = {
            ink = {
                ui = {
                    bg = "#181818",
                },
            },
        },
    },
})
vim.cmd.colorscheme("kanso-ink")

-- Update packages
vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
end, {})

-- Delete packages
vim.api.nvim_create_user_command("PackDelete", function()
    -- 1. Grab all packages on disk and filter for inactive ones
    local inactive = {}
    for _, pkg in ipairs(vim.pack.get()) do
        if not pkg.active then
            table.insert(inactive, pkg.spec.name)
        end
    end

    if #inactive == 0 then
        vim.notify("No unused plugins found!", vim.log.levels.INFO)
        return
    end

    -- 2. Create a clean floating window UI
    local buf = vim.api.nvim_create_buf(false, true)
    local width = 50
    local height = math.min(#inactive + 4, 20)

    -- Pad names with unchecked boxes for visual state
    local lines = { " [ ] Press <Space> to toggle, <Enter> to delete ", string.rep("─", width), "" }
    for _, name in ipairs(inactive) do
        table.insert(lines, "  [ ] " .. name)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2,
        style = "minimal",
        border = "rounded",
        title = " Delete Unused Packages ",
    })

    -- 3. Map <Space> to toggle "[ ]" to "[x]"
    vim.keymap.set("n", "<space>", function()
        local row = vim.api.nvim_win_get_cursor(win)[1]
        if row <= 3 then
            return
        end -- Don't toggle header rows

        vim.bo[buf].modifiable = true
        local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
        if line:match("%[ %]") then
            line = line:gsub("%[ %]", "[x]")
        else
            line = line:gsub("%[x%]", "[ ]")
        end
        vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { line })
        vim.bo[buf].modifiable = false
    end, { buffer = buf, silent = true })

    -- 4. Map <Enter> to execute batch delete
    vim.keymap.set("n", "<cr>", function()
        local all_lines = vim.api.nvim_buf_get_lines(buf, 3, -1, false)
        local targets = {}

        for _, line in ipairs(all_lines) do
            if line:match("%[x%]") then
                local name = line:gsub("^%s*%[x%]%s*", "")
                table.insert(targets, name)
            end
        end

        vim.api.nvim_win_close(win, true)

        if #targets > 0 then
            -- Batch delete via native vim.pack
            vim.pack.del(targets)
            vim.notify("Successfully deleted: " .. table.concat(targets, ", "), vim.log.levels.INFO)
        else
            vim.notify("No packages were selected for deletion.", vim.log.levels.WARN)
        end
    end, { buffer = buf, silent = true })

    -- Map <Esc> or 'q' to close without deleting
    local close_opts = { buffer = buf, silent = true }
    vim.keymap.set("n", "<esc>", function()
        vim.api.nvim_win_close(win, true)
    end, close_opts)
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
    end, close_opts)
end, {})
