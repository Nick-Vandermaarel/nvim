local M = {}

local function enhanced_hover()
    -- Quick filetype check
    if vim.bo.filetype ~= 'cs' then
        vim.lsp.buf.hover()
        return
    end

    -- Cached parent name pattern for better performance
    local parent_pattern = ":%s*(%w+)"

    -- Optimize meaningful hover check
    local function is_meaningful_hover(result)
        if not result or not result.contents then return false end

        local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        if #contents == 0 or (#contents == 1 and contents[1]:match("^%s*$")) then
            return false
        end

        -- Use ipairs for better performance on arrays
        for _, line in ipairs(contents) do
            if line:match("^///") then return true end
        end
        return false
    end

    -- Function to display hover information
    local function display_hover(result)
        if is_meaningful_hover(result) then
            local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
            vim.lsp.util.open_floating_preview(contents, "markdown", {
                border = "rounded",
                focus = false
            })
            return true
        end
        return false
    end

    -- Get hover information for current position
    vim.lsp.buf_request(0, 'textDocument/hover', vim.lsp.util.make_position_params(), function(_, result)
        if display_hover(result) then
            -- Only look for parent if we displayed something
            local line = vim.api.nvim_get_current_line()
            local parent_match_pos = line:find(parent_pattern)

            -- Only proceed if we found a parent
            if parent_match_pos then
                local parent_name = line:match(parent_pattern)
                if parent_name then
                    -- Create params only when needed
                    local parent_params = vim.lsp.util.make_position_params()
                    parent_params.position.character = line:find(parent_name) - 1

                    vim.lsp.buf_request(0, 'textDocument/hover', parent_params, function(_, parent_result)
                        if is_meaningful_hover(parent_result) then
                            vim.defer_fn(function()
                                display_hover(parent_result)
                            end, 100)
                        end
                    end)
                end
            end
        else
            vim.lsp.buf.hover()
        end
    end)
end
--- Base on_attach event for LSP
function M.onAttach(event)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc, remap = false })
    end

    nmap("K", enhanced_hover, "Enhanced Hover Documentation");
    -- Don't use these right now, and they are conflicting with mini.surround. Need to evaulate mapping.
    -- nmap("sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")
    -- nmap("sd", vim.diagnostic.open_float, "Show line [d]iagnostics");
    nmap("[d", vim.diagnostic.goto_next)
    nmap("]d", vim.diagnostic.goto_prev)
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
        client.request = function(method, params, handler, bufnr)
            if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
                return request_inner(method, params, handler, bufnr)
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
            }, handler, bufnr)
        end
    end
end

--- Default capabilities for LSP's
function M.default_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }

    capabilities = vim.tbl_deep_extend("force", capabilities, {
        textDocument = {
            completion = {
                completionItem = {
                    commitCharactersSupport = true,
                    deprecatedSupport = true,
                    documentationFormat = { "markdown", "plaintext" },
                    preselectSupport = true,
                    insertReplaceSupport = true,
                }
            }
        }
    })
    return capabilities;
end

return M;
