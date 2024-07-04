local M = {}

--- Base on_attach event for LSP
function M.onAttach(event)
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

--- Adding semantic highlights for roslyn lsp
function M.roslynSemanticHighlights(client)
    -- make sure this happens once per client, not per buffer
    if not client.is_hacked then
        client.is_hacked = true

        -- let the runtime know the server can do semanticTokens/full now
        client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
            semanticTokensProvider = {
                full = true,
            },
        })

        -- monkey patch the request proxy
        local request_inner = client.request
        client.request = function(method, params, handler)
            if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
                return request_inner(method, params, handler)
            end

            local function find_buf_by_uri(search_uri)
                local bufs = vim.api.nvim_list_bufs()
                for _, buf in ipairs(bufs) do
                    if vim.api.nvim_buf_is_valid(buf) then
                        local name = vim.api.nvim_buf_get_name(buf)
                        local uri = vim.uri_from_fname(name)
                        if uri == search_uri then
                            return buf
                        end
                    end
                end
            end

            local doc_uri = params.textDocument.uri

            local target_bufnr = find_buf_by_uri(doc_uri)
            local line_count = vim.api.nvim_buf_line_count(target_bufnr)
            local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

            return request_inner("textDocument/semanticTokens/range", {
                textDocument = params.textDocument,
                range = {
                    ["start"] = {
                        line = 0,
                        character = 0,
                    },
                    ["end"] = {
                        line = line_count - 1,
                        character = string.len(last_line) - 1,
                    },
                },
            }, handler)
        end
    end
end

return M;
