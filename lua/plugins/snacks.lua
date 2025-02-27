return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        input = { enabled = true },
        notifier = { enabled = true },
        indent = {
            priority = 1,
            enabled = true,
            animate = { enabled = false },
        },
        words = {
            enabled = true,
        }
    }
}
