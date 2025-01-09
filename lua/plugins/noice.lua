return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- Set default view for all notifications to mini
        notify = {
            -- Set the default view to mini
            view = "mini",
            -- Set the default position to bottom right
            replace = false,
            merge = false
        },
        messages = {
            view = "mini",
            view_warn = "mini"
        },
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        views = {
            cmdline_popup = {
                position = {
                    row = "90%",
                    col = "50%",
                }
            },
            -- Add mini view configuration to ensure it's in bottom right
            mini = {
                position = {
                    row = "90%",
                    col = "100%",
                },
                win_options = {
                    winblend = 0
                }
            }
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
        },
        routes = {
            { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}
