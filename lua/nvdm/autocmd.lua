vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    callback = function(args)
        require("conform").format({
            bufnr = args.buf,
            async = false,
            timeout_ms = 5000,
            lsp_fallback = true,
        })
    end,
});

-- Hack for roslyn lsp, to refresh diagnostics on insert leave
vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
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

-- Throttle Roslyn LSP refreshes
local roslyn_timer = nil
vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
    pattern = "*.cs", -- Only for C# files
    callback = function()
        -- Cancel previous timer if still pending
        if roslyn_timer then
            vim.fn.timer_stop(roslyn_timer)
        end

        -- Debounce the refresh
        roslyn_timer = vim.fn.timer_start(200, function()
            local clients = vim.lsp.get_clients({ name = "roslyn" })
            if not clients or #clients == 0 then
                return
            end

            local bufnr = vim.api.nvim_get_current_buf()
            if not vim.lsp.buf_is_attached(bufnr, clients[1].id) then
                return
            end

            vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = bufnr })
        end)
    end,
})

-- Debounce codelens refreshes
local codelens_timer = nil
vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWritePost",
    "LspAttach",
}, {
    pattern = "*.cs",
    callback = function()
        -- Cancel previous timer if still pending
        if codelens_timer then
            vim.fn.timer_stop(codelens_timer)
        end

        -- Debounce the refresh
        codelens_timer = vim.fn.timer_start(200, function()
            vim.lsp.codelens.refresh({ bufnr = 0 })
        end)
    end,
    desc = "Refresh codelens"
})
