return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    keys = {
        { "<leader>ee", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" } },
        { "<leader>ef", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer or current file" } },
        { "<leader>er", ":NvimTreeRefresh<CR>", { desc = "Refresh file explorer" } },
    },
    config = function()
        local function custom_on_attatch(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            api.config.mappings.default_on_attach(bufnr)

            -- custom easy-dotnet config.
            vim.keymap.set("n", "A", function()
                local node = api.tree.get_node_under_cursor()
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
            on_attach = custom_on_attatch,
        })
    end,
}
