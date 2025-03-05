local M = {}

local function enhanced_hover()
    -- Check if the current buffer is a C# file
    if vim.bo.filetype ~= 'cs' then
        -- If not a C# file, fall back to the default hover behavior
        vim.lsp.buf.hover()
        return
    end

    -- Function to check if hover content is meaningful
    local function is_meaningful_hover(result)
        if not result or not result.contents then
            return false
        end
        local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        -- Check if contents are not empty and contain more than just whitespace
        if #contents == 0 or (
                #contents == 1 and contents[1]:match("^%s*$")
            ) then
            return false
        end
        -- Check for presence of code comments (lines starting with ///)
        for _, line in ipairs(contents) do
            if line:match("^///") then
                return true
            end
        end
        return false
    end

    -- Function to display hover information
    local function display_hover(result)
        if is_meaningful_hover(result) then
            local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
            vim.lsp.util.open_floating_preview(contents, "markdown", {})
            return true
        end
        return false
    end

    -- Get hover information for current position
    vim.lsp.buf_request(0, 'textDocument/hover', vim.lsp.util.make_position_params(), function(_, result)
        local hover_displayed = display_hover(result)

        if hover_displayed then
            -- Try to find parent class or interface
            local line = vim.api.nvim_get_current_line()
            local parent_name = line:match(":%s*(%w+)")
            if parent_name then
                -- Create a new params object for the parent
                local parent_params = vim.lsp.util.make_position_params()
                parent_params.position.character = line:find(parent_name) - 1
                -- Get hover information for parent/interface
                vim.lsp.buf_request(0, 'textDocument/hover', parent_params, function(_, parent_result)
                    if is_meaningful_hover(parent_result) then
                        vim.defer_fn(function()
                            display_hover(parent_result)
                        end, 100) -- Slight delay to ensure it appears after the first hover
                    end
                end)
            end
        else
            -- If no meaningful hover information for current symbol, fall back to default behavior
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
    return capabilities;
end

return M;
