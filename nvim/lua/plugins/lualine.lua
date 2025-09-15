return {
    { -- 状态栏
        "nvim-lualine/lualine.nvim",
        cond = not vim.g.vscode,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'onedark',
                },
                extensions = {
                    'lazy',
                    'man',
                    {
                        sections = {
                            lualine_a = { function()
                                return "FILES"
                            end }
                        },
                        filetypes = { 'NvimTree' },
                    }
                },
            }
        end
    }
}
