local M = {}

function M.session()
    local ok, dap = pcall(require, "dap")
    if not ok then
        return nil
    end

    return dap.session()
end

function M.statusline()
    local ok, dap = pcall(require, "dap")
    if not ok or not dap.session() then
        return ""
    end

    local status = dap.status()
    if status == "" then
        return " DAP"
    end

    return " " .. status
end

function M.refresh_lualine()
    local ok, lualine = pcall(require, "lualine")
    if ok then
        lualine.refresh({ place = { "statusline" } })
    end
end

function M.setup_signs()
    vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#ff9e3b", bold = true })

    vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpoint",
        numhl = "DapBreakpoint",
    })

    vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DapStopped",
        linehl = "debugPC",
        numhl = "DapStopped",
    })
end

function M.create_help_element()
    local buf

    local function style_help_windows(help_buf)
        for _, win in ipairs(vim.fn.win_findbuf(help_buf)) do
            vim.wo[win].colorcolumn = ""
            vim.wo[win].cursorline = false
            vim.wo[win].wrap = false
            vim.wo[win].winhighlight = "Normal:DapUINormal,EndOfBuffer:DapUIEndOfBuffer,CursorLine:DapUINormal"
        end
    end

    local function ensure_buf()
        if buf and vim.api.nvim_buf_is_valid(buf) then
            return buf
        end

        buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].modifiable = false
        return buf
    end

    return {
        render = function()
            local help_buf = ensure_buf()
            local lines = {
                "F5 continue F10 over  F11 into  F12 out | <leader>b breakpoint  <leader>dr repl  <leader>dq stop  <leader>dx clear",
            }

            vim.bo[help_buf].modifiable = true
            vim.api.nvim_buf_set_lines(help_buf, 0, -1, false, lines)
            vim.bo[help_buf].modifiable = false
            style_help_windows(help_buf)
        end,
        buffer = function()
            local help_buf = ensure_buf()
            style_help_windows(help_buf)
            return help_buf
        end,
        allow_without_session = true,
    }
end

return M
