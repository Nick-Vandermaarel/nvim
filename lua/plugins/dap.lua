return {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio"
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<Leader>tb", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue Debugging" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })

        vim.fn.sign_define('DapBreakpoint', {
            text = '●',
            texthl = 'DapBreakpoint',
            linehl = '',
            numhl = ''
        })

        vim.fn.sign_define('DapStopped', {
            text = '▶',
            texthl = 'DapStopped',
            linehl = 'DapStoppedLine',
            numhl = 'DapStoppedLineNr'
        })

        vim.cmd([[
            highlight DapBreakpoint guifg=#FF0000 ctermfg=red
            highlight DapStopped guifg=#00FF00 ctermfg=green
            highlight DapStoppedLine guibg=#2d3d45 ctermbg=237
            highlight DapStoppedLineNr guifg=#00FF00 ctermfg=green
        ]])

        local easyDotNetDap = require("nvdm.easy-dotnet-dap");
        easyDotNetDap.register_net_dap();
    end
}
