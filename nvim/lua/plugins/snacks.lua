return {
    {
        "folke/snacks.nvim",
        cond = not vim.g.vscode,
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = false },
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
            { "<space><space>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
            { "<space>,",       function() Snacks.picker.buffers() end,         desc = "Buffers" },
            { "<space>/",       function() Snacks.picker.grep() end,            desc = "Grep" },
            { "<space>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<space>n",       function() Snacks.picker.notifications() end,   desc = "Notification History" },
            { "<space>.",       function() Snacks.scratch() end,                desc = "Toggle Scratch Buffer" },
            { "<space>S",       function() Snacks.scratch.select() end,         desc = "Select Scratch Buffer" },
            -- git
            { "<space>gF",      function() Snacks.picker.files() end,           desc = "Find Files" },
            { "<space>gf",      function() Snacks.picker.git_files() end,       desc = "Find Git Files" },
            { "<space>gb",      function() Snacks.picker.git_branches() end,    desc = "Git Branches" },
            { "<space>gl",      function() Snacks.picker.git_log() end,         desc = "Git Log" },
            { "<space>gL",      function() Snacks.picker.git_log_line() end,    desc = "Git Log Line" },
            { "<space>gs",      function() Snacks.picker.git_status() end,      desc = "Git Status" },
            { "<space>gd",      function() Snacks.picker.git_diff() end,        desc = "Git Diff (Hunks)" },
            { "<space>gB",      function() Snacks.gitbrowse() end,              desc = "Git Browse" },
            -- Grep
            { "<space>sb",      function() Snacks.picker.lines() end,           desc = "Buffer Lines" },
            { "<space>sB",      function() Snacks.picker.grep_buffers() end,    desc = "Grep Open Buffers" },
            -- search
            { '<space>s"',      function() Snacks.picker.registers() end,       desc = "Registers" },
            { '<space>s/',      function() Snacks.picker.search_history() end,  desc = "Search History" },
            { "<space>sa",      function() Snacks.picker.autocmds() end,        desc = "Autocmds" },
            { "<space>sc",      function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<space>sC",      function() Snacks.picker.commands() end,        desc = "Commands" },
            { "<space>sh",      function() Snacks.picker.help() end,            desc = "Help Pages" },
            { "<space>sH",      function() Snacks.picker.highlights() end,      desc = "Highlights" },
            { "<space>sj",      function() Snacks.picker.jumps() end,           desc = "Jumps" },
            { "<space>sk",      function() Snacks.picker.keymaps() end,         desc = "Keymaps" },
            { "<space>sm",      function() Snacks.picker.marks() end,           desc = "Marks" },
            { "<space>sM",      function() Snacks.picker.man() end,             desc = "Man Pages" },
            { "<space>sp",      function() Snacks.picker.lazy() end,            desc = "Search for Plugin Spec" },
            { "<space>sq",      function() Snacks.picker.qflist() end,          desc = "Quickfix List" },
            { "<space>su",      function() Snacks.picker.undo() end,            desc = "Undo History" },
            { "<space>uC",      function() Snacks.picker.colorschemes() end,    desc = "Colorschemes" },
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
