return {
    "mfussenegger/nvim-dap",
    keys = {
        {
            "<Leader>tb",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Toggle Breakpoint",
        },
        {
            "<F5>",
            function()
                require("dap").continue()
            end,
            desc = "Continue Debugging",
        },
        {
            "<F10>",
            function()
                require("dap").step_over()
            end,
            desc = "Step Over",
        },
        {
            "<F11>",
            function()
                require("dap").step_into()
            end,
            desc = "Step Into",
        },
        {
            "<F12>",
            function()
                require("dap").step_out()
            end,
            desc = "Step Out",
        },
    },
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
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

        vim.fn.sign_define("DapBreakpoint", {
            text = "●",
            texthl = "DapBreakpoint",
            linehl = "",
            numhl = "",
        })

        vim.fn.sign_define("DapStopped", {
            text = "▶",
            texthl = "DapStopped",
            linehl = "DapStoppedLine",
            numhl = "DapStoppedLineNr",
        })

        vim.cmd([[
            highlight DapBreakpoint guifg=#FF0000 ctermfg=red
            highlight DapStopped guifg=#00FF00 ctermfg=green
            highlight DapStoppedLine guibg=#2d3d45 ctermbg=237
            highlight DapStoppedLineNr guifg=#00FF00 ctermfg=green
        ]])

        local easyDotNetDap = require("nvdm.easy-dotnet-dap")
        easyDotNetDap.register_net_dap()
    end,
}
