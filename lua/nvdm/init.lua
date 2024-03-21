local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Leader must be setup first so lazy can bind correctly.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins")

vim.cmd("colorscheme kanagawa")
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffe5b4', bold = true })

-- Gitblame config
vim.g.gitblame_display_virtual_text = 0 -- Remove virtual text from the buffer.
vim.g.gitblame_message_when_not_committed = "Not commited"
vim.g.gitblame_date_format = "%Y-%m-%d %H:%M"


-- Enable 24 bit color.
vim.opt.termguicolors = true

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

-- LSP Attach AutoCMD
vim.api.nvim_create_autocmd('LspAttach', {
    desc = "LSP actions",
    callback = function(event)
        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end

            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc, remap = false })
        end

        local builtin = require("telescope.builtin")
        nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinitions")
        nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
        nmap("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")
        nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        nmap("[d", function() vim.diagnostic.goto_next() end)
        nmap("]d", function() vim.diagnostic.goto_prev() end)
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)
    end
})

-- Auto format AutoCMD
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({
            bufnr = args.buf,
            async = true,
            lsp_fallback = true,
        })
    end,
})


require("nvdm.remap")
require("nvdm.set")

--require("gitsigns").setup()
--require("Comment").setup()
