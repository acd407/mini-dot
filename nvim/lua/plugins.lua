return {
    { -- 显示颜色
        "NvChad/nvim-colorizer.lua",
        cond = not vim.g.vscode,
        config = function()
            require("colorizer").setup {}
        end
    },
    { -- 显示git里增加，删除，编辑地方
        "lewis6991/gitsigns.nvim",
        cond = not vim.g.vscode,
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        "folke/which-key.nvim",
        cond = not vim.g.vscode,
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {}
    },
    { -- gcc和gc注释
        "numToStr/Comment.nvim",
        opts = {},
        config = function()
            require("Comment").setup()
        end,
    },
    { -- csv 编辑
        "hat0uma/csvview.nvim",
        config = function()
            require("csvview").setup()
        end
    },
    "nfnty/vim-nftables",
    {
        "fei6409/log-highlight.nvim",
        config = function()
            require("log-highlight").setup()
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        'chomosuke/typst-preview.nvim',
        cond = not vim.g.vscode,
        ft = 'typst',
        version = '1.*',
        opts = {
            dependencies_bin = {
                ['tinymist'] = "tinymist",
                ['websocat'] = "websocat"
            },
        }, -- lazy.nvim will implicitly calls `setup {}`
    },
}
