-- CSharp Using sort method - optimized
local function sort_usings()
    -- Only process visible part of buffer first to improve performance
    local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false) -- Just check first 100 lines

    -- Quick check if there are any usings before processing
    local has_usings = false
    for _, line in ipairs(lines) do
        if line:match('^using') then
            has_usings = true
            break
        end
    end

    if not has_usings then return end

    -- Now get full buffer only if we know we have usings
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- Find using statements
    local using_start, using_end
    local usings = {}
    local post_using_empty_lines = 0

    for i, line in ipairs(lines) do
        if line:match('^using') then
            if not using_start then using_start = i end
            table.insert(usings, line)
        elseif using_start and line:match('^%s*$') then
            post_using_empty_lines = post_using_empty_lines + 1
        elseif using_start and not line:match('^using') and not line:match('^%s*$') then
            using_end = i - 1 - post_using_empty_lines
            break
        end
    end

    -- Sort usings if found
    if #usings > 0 then
        table.sort(usings)
        -- Add back the empty lines
        for _ = 1, post_using_empty_lines do
            table.insert(usings, '')
        end
        -- Replace old usings with sorted ones, preserving empty lines
        vim.api.nvim_buf_set_lines(0, using_start - 1, using_end + post_using_empty_lines, false, usings)
    end
end

-- Split into C# specific and general format commands
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.cs",
    callback = function(args)
        -- Format
        require("conform").format({
            bufnr = args.buf,
            async = false,
            timeout_ms = 5000,
            lsp_fallback = true,
        })
        -- Sort usings
        sort_usings()
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*", "!*.cs" }, -- All files except .cs
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
