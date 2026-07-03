vim.pack.add({ "https://github.com/nvim-tree/nvim-tree.lua" })

local function custom_on_attach(bufnr)
    local api = require("nvim-tree.api")
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.map.on_attach.default(bufnr)

    -- custom easy-dotnet config.
    vim.keymap.set("n", "A", function()
        local node = api.tree.get_node_under_cursor()
        if node == nil then
            return
        end

        local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
        require("easy-dotnet").create_new_item(path)
    end, opts("Create file from dotnet template"))
end

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    renderer = {
        indent_markers = {
            enable = true,
        },
    },
    view = {
        width = 35,
        relativenumber = true,
    },
    actions = {
        open_file = {
            window_picker = {
                enable = false,
            },
        },
    },
    git = {
        ignore = true,
    },
    on_attach = custom_on_attach,
})

vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim tree" })
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer or current file" })
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
