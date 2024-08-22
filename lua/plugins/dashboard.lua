return {
    {
        'nvimdev/dashboard-nvim',
        lazy = false,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } },
        config = function()
            local db = require("dashboard")

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
            }

            local function get_random_quote()
                math.randomseed(os.time())
                return quotes[math.random(#quotes)]
            end

            local function get_footer()
                local datetime = os.date("%Y-%m-%d %H:%M:%S")

                local stats = {
                    string.format("%s", datetime)
                }

                return stats
            end

            db.setup {
                theme = "doom",
                config = {
                    header = {
                        [[]],
                        [[]],
                        [[]],
                        [[]],
                        [[]],
                        [[]],
                        [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
                        [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
                        [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
                        [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
                        [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
                        [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                        [[]],
                        [[]],
                        get_random_quote(),
                        [[]],
                        [[]],
                    },
                    center = {
                        { action = "Telescope fd", desc = " Browse files", icon = "󰈔 ", key = "f" },
                        { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
                        { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
                    },
                    footer = get_footer()
                }
            }
        end
    },
}
