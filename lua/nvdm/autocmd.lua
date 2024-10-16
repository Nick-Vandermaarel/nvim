-- CSharp Using sort method.
-- Function to sort using statements while preserving spacing
local function sort_usings()
    -- Get buffer contents
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

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

        -- Plugin to sort usings on csharp files
        if vim.fn.expand("%:e") == "cs" then
            sort_usings()
        end
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

-- Roslyn Code lens auto cmd
-- local codelens_refresh_timer = nil
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
--     pattern = "*.cs",
--     callback = function()
--         local clients = vim.lsp.get_clients()
--         for _, client in ipairs(clients) do
--             if client.name == "roslyn" then
--                 vim.lsp.codelens.refresh()
--                 break
--             end
--         end
--     end,
-- })
--
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--     pattern = "*.cs",
--     callback = function()
--         if codelens_refresh_timer then
--             vim.fn.timer_stop(codelens_refresh_timer)
--         end
--         codelens_refresh_timer = vim.fn.timer_start(1000, function()
--             local clients = vim.lsp.get_clients()
--             for _, client in ipairs(clients) do
--                 if client.name == "roslyn" then
--                     vim.lsp.codelens.refresh()
--                     break
--                 end
--             end
--         end)
--     end,
-- })
