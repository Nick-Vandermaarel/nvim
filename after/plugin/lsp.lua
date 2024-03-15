require("neoconf").setup()
require("neodev").setup()

vim.api.nvim_create_autocmd('LspAttach', {
    desc = "LSP actions",
    callback = function(event)
        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end

            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc, remap = false })
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
    end
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities();

local default_setup = function(server)
    require('lspconfig')[server].setup({
        capabilities = lsp_capabilities,
    })
end

local function organizeImports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        "lua_ls",
        'tsserver',
        'volar',
        'eslint',
        'html',
        'rust_analyzer'
    },
    handlers = {
        default_setup,
        tsserver = function()
            require('lspconfig').tsserver.setup({
                capabilities = lsp_capabilities,
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                            languages = { "vue" },
                        }
                    }
                },
                filetypes = { "typescript", "javascript", "vue" },
                commands = {
                    OrganizeImports = {
                        organizeImports,
                        description = "Organize Imports"
                    }
                },
            })
        end,
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local luasnip = require("luasnip")
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    sources = cmp.config.sources({
        { name = "copilot" },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = "luasnip" },
        { name = "path" },
    }),
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            maxwidth = 50,
            ellipsis_char = "..."
        }),
    },
    window = {
        documentation = cmp.config.window.bordered()
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- Select the next item
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        -- select the previous item
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

        -- Accept the completion. Default is <c-y>
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),

        -- Manually trigger a completion from nvim-cmp
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})
