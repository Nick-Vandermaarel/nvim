vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.HINT] = "●",
            [vim.diagnostic.severity.INFO] = "●",
        },
        texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
    },
    underline = true,
    update_in_insert = true,
})

local r = require("nvdm.remap")

-- Diagnostic navigation
r.Map("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
    vim.cmd("normal! zz")
end)

r.Map("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
    vim.cmd("normal! zz")
end)
