local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        "--depth=1",
        lazypath,
    })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- 外观 --------------------------------------------------------------------
    { -- 状态栏
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("plugins.lualine")
        end
    },
    { -- 主题
        "navarasu/onedark.nvim",
        config = function()
            require("plugins.onedark")
        end
    },
    { -- 显示颜色
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup {}
        end
    },
    { -- 代码块缩进显示插件
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent-blankline")
        end
    },
    { -- 显示git里增加，删除，编辑地方
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    -- 小方便 ------------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {}
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end
    },
    { -- gcc和gc注释
        "numToStr/Comment.nvim",
        opts = {},
        config = function()
            require("Comment").setup()
        end,
    },
    { -- smart fold
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require("plugins.ufo")
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("plugins.telescope")
        end
    },
    -- 单个语言相关 ------------------------------------------------------------
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
    -- lsp ---------------------------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.lsp")
        end
    },
    -- 补全信息来源、整合
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    -- snippet
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip", -- wrapper
    "rafamadriz/friendly-snippets",
    {
        "hrsh7th/nvim-cmp",
        config = function()
            require("plugins.cmp")
        end,
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require("plugins.null-ls")
        end
    },
    { -- 语法高亮
        "nvim-treesitter/nvim-treesitter",
        build = "<Cmd>TSUpdate",
        config = function()
            require("plugins.treesitter")
        end
    },
    { -- 显示当前函数
        "nvim-treesitter/nvim-treesitter-context",
    },
    -- 无关的小物件 ------------------------------------------------------------
    "dstein64/vim-startuptime",
    {
        "voldikss/vim-floaterm", -- 浮动终端
        config = function()
            require("plugins.term")
        end
    },
    { -- 文件管理器
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("plugins.nvim-tree")
        end,
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}

require("lazy").setup(plugins, {})
