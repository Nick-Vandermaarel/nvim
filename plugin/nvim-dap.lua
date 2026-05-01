vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/rcarriga/nvim-dap-ui",
})

-- Some extensions may have DAP setup built in (easy-dotnet). Otherwise language setup will be required here.

local dap = require("dap")
local dap_custom = require("nvdm.dap")

dap_custom.setup_signs()

vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate DAP" })
vim.keymap.set("n", "<leader>dx", dap.clear_breakpoints, { desc = "Clear DAP breakpoints" })

vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/continue debugging" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step over (alt)" })
vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle DAP REPL" })
vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Go down stack frame" })
vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Go up stack frame" })

-- UI config
local dapui = require("dapui")

dapui.register_element("dap_help", dap_custom.create_help_element())

dapui.setup({
    layouts = {
        {
            elements = {
                "dap_help",
            },
            size = 2,
            position = "top",
        },
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                { id = "easy-dotnet_cpu", size = 0.5 }, -- CPU usage panel (50% of layout)
                { id = "easy-dotnet_mem", size = 0.5 }, -- Memory usage panel (50% of layout)
            },
            size = 35, -- Width of the sidebar
            position = "right",
        },
        {
            elements = {
                "console",
            },
            size = 10,
            position = "bottom",
        },
    },
})

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end

dap.listeners.after.event_initialized.dap_lualine = function()
    vim.schedule(dap_custom.refresh_lualine)
end

dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end

dap.listeners.before.event_terminated.dap_lualine = function()
    vim.schedule(dap_custom.refresh_lualine)
end

dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

dap.listeners.before.event_exited.dap_lualine = function()
    vim.schedule(dap_custom.refresh_lualine)
end
