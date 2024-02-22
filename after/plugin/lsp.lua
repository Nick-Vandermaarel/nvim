local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    local builtin = require("telescope.builtin")
    nmap("gd", "<cmd>Lspsaga goto_definition<CR>", "[G]oto [D]efinitions")
    nmap("pd", "<cmd>Lspsaga peek_definition<CR>", "[P]eek [D]efinitions")
    nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    nmap("K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    nmap("[d", function() vim.diagnostic.goto_next() end)
    nmap("]d", function() vim.diagnostic.goto_prev() end)
    nmap("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
    nmap("<leader>rn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)
end)

require("neoconf").setup()
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'tsserver', 'eslint', 'html', 'rust_analyzer' },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

require("lspconfig").volar.setup {
    filetypes = { "typescript", "javascript", "vue", "json" }
}

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<enter>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})
