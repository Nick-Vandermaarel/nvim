local lspUtils = require("nvdm.lspUtils")

-- LSP Attach AutoCMD
vim.api.nvim_create_autocmd('LspAttach', {
    desc = "LSP actions",
    callback = function(event)
        lspUtils.onAttach(event);
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
vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold" }, {
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
