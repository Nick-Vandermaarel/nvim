return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        views = {
            cmdline_popup = {
                position = {
                    row = "90%",
                    col = "50%",
                }
            },
            notify = {
                -- Save messages are notifications, so we can adjust their size here
                replace = true,
                merge = true,
                level = "INFO",
            },
            mini = {
                -- Make the mini view (used for save messages) smaller
                win_options = {
                    winblend = 0,
                    winhighlight = {
                        Normal = "NoiceMini",
                        IncSearch = "",
                        Search = "",
                    },
                },
                position = {
                    row = -2,     -- Closer to bottom
                    col = "100%", -- Right aligned
                    width = "auto",
                },
                size = {
                    height = 1, -- Just one line
                    width = "auto",
                },
                border = {
                    style = "none",
                },
            },
        },
        routes = {
            {
                -- Route file save messages to mini view
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                view = "mini"
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true,         -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}
