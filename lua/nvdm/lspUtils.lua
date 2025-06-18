local M = {}

function M.toggle_basedpyright_settings(opts)
    opts = opts or {}

    -- Get the LSP client for basedpyright
    local client = vim.lsp.get_clients({ name = "basedpyright" })[1]
    if not client then
        vim.notify("BasedPyright LSP is not active", vim.log.levels.WARN)
        return
    end

    -- Toggle the typeCheckingMode
    local analysis = client.config.settings.basedpyright.analysis
    if analysis.typeCheckingMode == "basic" then
        analysis.typeCheckingMode = "recommended"
    else
        analysis.typeCheckingMode = "basic"
    end

    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })

    if not opts.silent then
        vim.notify("TypeCheckingMode: " .. analysis.typeCheckingMode)
    end
end

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

    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()

    -- Get hover information for current position
    vim.lsp.buf_request(bufnr, 'textDocument/hover', vim.lsp.util.make_position_params(winnr, "utf-16"),
        function(_, result)
            if display_hover(result) then
                -- Only look for parent if we displayed something
                local line = vim.api.nvim_get_current_line()
                local parent_match_pos = line:find(parent_pattern)

                -- Only proceed if we found a parent
                if parent_match_pos then
                    local parent_name = line:match(parent_pattern)
                    if parent_name then
                        -- Create params only when needed
                        local parent_params = vim.lsp.util.make_position_params(winnr, "utf-16")
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

    nmap("<leader>bp", function() M.toggle_basedpyright_settings() end, "Toggle BasedPyright Settings")

    nmap("K", enhanced_hover, "Enhanced Hover Documentation");
    nmap("<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")
    nmap("<leader>sd", vim.diagnostic.open_float, "Show line [d]iagnostics");
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)
end

return M;
