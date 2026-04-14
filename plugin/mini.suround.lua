vim.pack.add({ "https://github.com/nvim-mini/mini.surround" })
local MiniSurround = require("mini.surround")
MiniSurround.setup({
    -- Allows for tag replacements while keeping the inner content (attributes)
    custom_surroundings = {
        T = {
            input = { "<(%w+)[^<>]->.-</%1>", "^<()%w+().*</()%w+()>$" },
            output = function()
                local tag_name = MiniSurround.user_input("Tag name")
                if tag_name == nil then
                    return nil
                end
                return { left = tag_name, right = tag_name }
            end,
        },
    },
    n_lines = 100,
})
