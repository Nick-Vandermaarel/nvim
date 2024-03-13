local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    local builtin = require("telescope.builtin")
    nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinitions")
    nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")
    nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    nmap("[d", function() vim.diagnostic.goto_next() end)
    nmap("]d", function() vim.diagnostic.goto_prev() end)
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)
end)

require("neoconf").setup()
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'tsserver', 'volar', 'eslint', 'html', 'rust_analyzer' },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

local function organizeImports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

require("lspconfig").tsserver.setup {
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "typescript", "javascript", "vue" },
            }
        }
    },
    filetypes = { "typescript", "javascript", "vue" },
    commands = {
        OrganizeImports = {
            organizeImports,
            description = "Organize Imports"
        }
    }
}

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
    window = {
        documentation = cmp.config.window.bordered()
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        -- Select the next item
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        -- select the previous item
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

        -- Accept the completion. Default is <c-y>
        ['<enter>'] = cmp.mapping.confirm({ select = true }),

        -- Manually trigger a completion from nvim-cmp
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})
