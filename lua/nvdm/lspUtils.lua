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

--- Base on_attach event for LSP
function M.onAttach(event)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc, remap = false })
    end

    nmap("<leader>bp", function()
        M.toggle_basedpyright_settings()
    end, "Toggle BasedPyright Settings")

    nmap("K", vim.lsp.buf.hover, "Hover")
    nmap("<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")
    nmap("<leader>sd", vim.diagnostic.open_float, "Show line [d]iagnostics")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = event.buf })
end

return M
