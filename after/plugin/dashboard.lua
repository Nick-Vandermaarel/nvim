local db = require("dashboard")

db.setup {
    theme = "doom",
    config = {
        header = {
            [[]],
            [[]],
            [[]],
            [[]],
            [[]],
            [[          ▀████▀▄▄              ▄█ ]],
            [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
            [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
            [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
            [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
            [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
            [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
            [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
            [[   █   █  █      ▄▄           ▄▀   ]],
            [[]],
            [[]],
            [[]],
            [[]],
            [[]],
        },
        center = {
            { action = "Telescope fd", desc = " Browse files", icon = "󰈔 ", key = "f" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
            { action = 'lua require("telescope").extensions.project.project{}', desc = " Open Project", icon = "󱉥 ", key = "p" },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
        },
        footer = {}
    }
}
