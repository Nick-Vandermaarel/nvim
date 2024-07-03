--- On attach event for LSP
local onAttach = function(event)
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

-- LSP Attach AutoCMD
vim.api.nvim_create_autocmd('LspAttach', {
    desc = "LSP actions",
    callback = function(event)
        onAttach(event);
    end
})

-- Auto format AutoCMD
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({
            bufnr = args.buf,
            async = false,
            timeout_ms = 5000,
            lsp_fallback = true,
        })
    end,
})

-- Hack for roslyn lsp, to refresh diagnostics on insert leave
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = "*",
    callback = function()
        local clients = vim.lsp.get_clients({ name = "roslyn" })
        if not clients or #clients == 0 then
            return
        end

        local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
        for _, buf in ipairs(buffers) do
            vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
        end
    end,
})

return onAttach;
