local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

local quotes = {
    "The only way to do great work is to love what you do. - Steve Jobs",
    "It always seems impossible until it's done. - Nelson Mandela",
    "Code is like humor. When you have to explain it, it's bad. - Cory House",
    "First, solve the problem. Then, write the code. - John Johnson",
    "The best error message is the one that never shows up. - Thomas Fuchs",
    "Programming isn't about what you know; it's about what you can figure out. - Chris Pine",
    "The most disastrous thing that you can ever learn is your first programming language. - Alan Kay",
    "Sometimes it's better to leave something alone, to pause, and that's very true of programming. - Joyce Wheeler",
    "Testing leads to failure, and failure leads to understanding. - Burt Rutan",
    "Any fool can write code that a computer can understand. Good programmers write code that humans can understand. - Martin Fowler",
    "Experience is the name everyone gives to their mistakes. - Oscar Wilde",
    "The most important property of a program is whether it accomplishes the intention of its user. - C.A.R. Hoare",
    "Perfection is achieved not when there is nothing more to add, but rather when there is nothing more to take away. - Antoine de Saint-Exupery",
    "Don't comment bad code - rewrite it. - Brian Kernighan",
    "The function of good software is to make the complex appear to be simple. - Grady Booch",
    "There are two ways to write error-free programs; only the third one works. - Alan J. Perlis",
    "The best way to predict the future is to invent it. - Alan Kay",
    "Simplicity is the soul of efficiency. - Austin Freeman",
    "Before software can be reusable it first has to be usable. - Ralph Johnson",
    "Make it work, make it right, make it fast. - Kent Beck",
    "Computers are good at following instructions, but not at reading your mind. - Donald Knuth",
    "Every great developer you know got there by solving problems they were unqualified to solve until they actually did it. - Patrick McKenzie",
    "The only way to learn a new programming language is by writing programs in it. - Dennis Ritchie",
    "Sometimes it pays to stay in bed on Monday, rather than spending the rest of the week debugging Monday's code. - Dan Salomon",
    "Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it. - Brian Kernighan",
    "Walking on water and developing software from a specification are easy if both are frozen. - Edward V. Berard",
    "It's not a bug – it's an undocumented feature. - Anonymous",
    "One man's crappy software is another man's full-time job. - Jessica Gaston",
    "If debugging is the process of removing software bugs, then programming must be the process of putting them in. - Edsger W. Dijkstra",
    "Software and cathedrals are much the same – first we build them, then we pray. - Sam Redwine",
    "The computer was born to solve problems that did not exist before. - Bill Gates",
    "Software is a great combination of artistry and engineering. - Bill Gates",
    "Talk is cheap. Show me the code. - Linus Torvalds",
    "Good code is its own best documentation. - Steve McConnell",
    "The best thing about a boolean is even if you are wrong you are only off by a bit. - Anonymous",
    "If you think good architecture is expensive, try bad architecture. - Brian Foote and Joseph Yoder",
    "The Internet? We are not interested in it. - Bill Gates, 1993",
    "The most important single aspect of software development is to be clear about what you are trying to build. - Bjarne Stroustrup",
    "Measuring programming progress by lines of code is like measuring aircraft building progress by weight. - Bill Gates",
    "A language that doesn't affect the way you think about programming is not worth knowing. - Alan J. Perlis",
    "Most good programmers do programming not because they expect to get paid or get adulation by the public, but because it is fun to program. - Linus Torvalds",
    "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live. - John Woods",
    "Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the Universe trying to produce bigger and better idiots. So far, the Universe is winning. - Rick Cook",
    "The purpose of software engineering is to control complexity, not to create it. - Pamela Zave",
    "Copy and paste is a design error. - David Parnas",
    "If you automate a mess, you get an automated mess. - Rod Michael",
    "The first 90% of the code accounts for the first 90% of the development time. The remaining 10% of the code accounts for the other 90% of the development time. - Tom Cargill",
    "Programming is like sex. One mistake and you have to support it for the rest of your life. - Michael Sinz",
    "In theory, there is no difference between theory and practice. But, in practice, there is. - Jan L. A. van de Snepscheut",
    "The sooner you start to code, the longer the program will take. - Roy Carlson",
    "Plan to throw one away; you will, anyhow. - Fred Brooks",
    "Optimism is an occupational hazard of programming; feedback is the treatment. - Kent Beck",
    "When debugging, novices insert corrective code; experts remove defective code. - Richard Pattis",
    "Design is not just what it looks like and feels like. Design is how it works. - Steve Jobs",
    "The best method for accelerating a computer is the one that boosts it by 9.8 m/s2. - Anonymous",
    "I don't care if it works on your machine! We are not shipping your machine! - Vidiu Platon",
    "Deleted code is debugged code. - Jeff Sickel",
    "It's not a bug – it's an undocumented feature. - Anonymous",
    "Complexity is the root of all evil. - Me",
    "A computer can never be held accountable, therefore a computer must never make a management decision. - IBM 1979",
}

local function wrap_text(text, line_width)
    line_width = line_width or 60 -- Default line width if not specified

    local result = ""
    local line_length = 0
    local words = {}

    -- Split the text into words
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end

    -- Process each word
    for _, word in ipairs(words) do
        -- Check if adding this word would exceed the line width
        if line_length + #word + 1 > line_width and line_length > 0 then
            result = result .. "\n"
            line_length = 0
        elseif line_length > 0 then
            -- Add a space before the word if it's not the first word on the line
            result = result .. " "
            line_length = line_length + 1
        end

        -- Add the word
        result = result .. word
        line_length = line_length + #word
    end

    return result
end

local function get_random_quote()
    math.randomseed(os.time())
    return wrap_text(quotes[math.random(#quotes)], 80)
end

vim.pack.add({
    "https://github.com/folke/snacks.nvim",
})

require("snacks").setup({
    input = {},
    notifier = {},
    explorer = {},
    indent = {
        priority = 1,
        enabled = true,
        animate = { enabled = false },
        indent = {
            enabled = false,
        },
    },
    picker = {
        enabled = true,
        sources = {
            explorer = {
                hidden = false,
                ignored = false,
                exclude = {
                    ".godot/**",
                    ".import/**",
                    "*.import",
                    "*.uid",
                    "project.godot",
                },
            },
        },
    },
    -- this is nice, but only really works well with lazy.nvim right now.
    dashboard = {
        preset = {
            header = header,
            keys = {
                { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
        },
        sections = {
            { section = "header" },
            {
                footer = get_random_quote(),
                padding = 3,
            },
            { section = "keys", padding = 1 },
        },
    },
})

---@type snacks.Config
-- Picker keymaps
vim.keymap.set("n", "<leader>pb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>pc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>pf", function()
    Snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>pg", function()
    Snacks.picker.git_files()
end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>pp", function()
    Snacks.picker.projects()
end, { desc = "Projects" })
vim.keymap.set("n", "<leader>pr", function()
    Snacks.picker.recent()
end, { desc = "Recent" })

-- LSP
vim.keymap.set("n", "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function()
    Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function()
    Snacks.picker.lsp_references()
end, { desc = "References", nowait = true })
vim.keymap.set("n", "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })

-- Grep
vim.keymap.set("n", "<leader>sb", function()
    Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sg", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sB", function()
    Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })

-- Explorer
vim.keymap.set("n", "<leader>ee", Snacks.explorer.open, { desc = "Toggle explorer" })
vim.keymap.set("n", "<leader>ef", Snacks.explorer.reveal, { desc = "Toggle file explorer or current file" })
