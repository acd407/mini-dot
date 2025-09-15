return {
    {
        "folke/snacks.nvim",
        cond = not vim.g.vscode,
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = true },
            indent = { enabled = true, animate = { enabled = false } },
            input = { enabled = true },
            notifier = {
                enabled = false,
                timeout = 5000,
            },
            picker = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            styles = {
                notification = {
                    -- wo = { wrap = true } -- Wrap notifications
                }
            }
        },
        keys = {
            -- Top Pickers & Explorer
            { "<space><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
            { "<space>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<space>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<space>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<space>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
            { "<space>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
            -- find
            { "<space>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<space>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<space>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<space>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
            { "<space>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
            { "<space>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
            -- git
            { "<space>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
            { "<space>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
            { "<space>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
            { "<space>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
            { "<space>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
            { "<space>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
            { "<space>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
            -- Grep
            { "<space>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
            { "<space>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
            { "<space>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<space>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
            -- search
            { '<space>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
            { '<space>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
            { "<space>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
            { "<space>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
            { "<space>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<space>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
            { "<space>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
            { "<space>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
            { "<space>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
            { "<space>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
            { "<space>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
            { "<space>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
            { "<space>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
            { "<space>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
            { "<space>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
            { "<space>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
            { "<space>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
            { "<space>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
            { "<space>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
            { "<space>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
            { "<space>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
            -- LSP
            { "gd",             function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
            { "gD",             function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
            { "gr",             function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
            { "gI",             function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
            { "gy",             function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
            { "g[",             vim.diagnostic.goto_prev,                                               desc = "Goto Next Diagnostics" },
            { "g]",             vim.diagnostic.goto_next,                                               desc = "Goto Prev Diagnostics" },
            { "<space>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
            { "<space>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
            -- Other
            { "<space>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
            { "<space>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
            { "<space>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
            { "<space>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
            { "<space>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
            { "<space>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
            { "<space>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
            { "<space>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
            { "<c-/>",          function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
            { "]]",             function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",           mode = { "n", "t" } },
            { "[[",             function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",           mode = { "n", "t" } },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<space>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<space>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<space>uL")
                    Snacks.toggle.diagnostics():map("<space>ud")
                    Snacks.toggle.line_number():map("<space>ul")
                    Snacks.toggle.option("conceallevel",
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<space>uc")
                    Snacks.toggle.treesitter():map("<space>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                        "<space>ub")
                    Snacks.toggle.inlay_hints():map("<space>uh")
                    Snacks.toggle.indent():map("<space>ug")
                    Snacks.toggle.dim():map("<space>uD")
                end,
            })
        end,
    }
}
