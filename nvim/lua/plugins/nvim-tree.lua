return {
    { -- 文件管理器
        "nvim-tree/nvim-tree.lua",
        cond = not vim.g.vscode,
        config = function()
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- optionally enable 24-bit colour
            vim.opt.termguicolors = true

            local api = require("nvim-tree.api")
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
            end
            vim.keymap.set("n", "<space>e", function()
                api.tree.toggle({ path = vim.fn.getcwd(), find_file = false, update_root = false, focus = true, })
            end, opts("toggle"))

            require("nvim-tree").setup({
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                    icons = {
                        symlink_arrow = " 󰁕 "
                    },
                },
                filters = {
                    dotfiles = true,
                },
            })
        end,
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }
}
