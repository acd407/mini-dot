return {
    { -- 文件管理器
        "nvim-tree/nvim-tree.lua",
        config = function()
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- optionally enable 24-bit colour
            vim.opt.termguicolors = true

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

            vim.api.nvim_set_keymap("n", "<space>e", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
        end,
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    }
}
