if vim.g.vscode then
    -- 在你的 Neovim 配置中（init.lua 或类似文件）
    vim.keymap.set('n', '<space>ff', function()
        vim.fn.VSCodeNotify('editor.action.formatDocument') -- 格式化文档
    end, { silent = true })

    vim.keymap.set('n', '<space>fr', function()
        vim.fn.VSCodeNotify('editor.action.rename') -- 重命名符号
    end, { silent = true })

    vim.keymap.set('n', '<space>fa', function()
        vim.fn.VSCodeNotify('editor.action.quickFix') -- 代码操作（Quick Fix）
    end, { silent = true })

    -- Workspace 相关（VS Code 没有完全等效的功能，但可以近似）
    vim.keymap.set('n', '<space>wa', function()
        vim.fn.VSCodeNotify('workbench.action.addRootFolder') -- 添加工作区文件夹
    end, { silent = true })

    vim.keymap.set('n', '<space>wr', function()
        vim.fn.VSCodeNotify('workbench.action.removeRootFolder') -- 移除工作区文件夹
    end, { silent = true })

    vim.keymap.set('n', '<space>wl', function()
        vim.fn.VSCodeNotify('workbench.action.quickOpen') -- 查看工作区文件夹（近似）
    end, { silent = true })

    -- 悬浮诊断信息
    vim.keymap.set('n', '<C-k>', function()
        vim.fn.VSCodeNotify('editor.action.showHover') -- 显示悬停信息
    end, { silent = true })

    -- 查看类型定义（Treesitter 相关，VS Code 无直接等效）
    vim.keymap.set('n', 'gt', function()
        vim.fn.VSCodeNotify('editor.action.goToTypeDefinition') -- 跳转到类型定义
    end, { silent = true })

    -- 查看文档（Hover）
    vim.keymap.set('n', 'K', function()
        vim.fn.VSCodeNotify('editor.action.showHover') -- 显示悬停信息
    end, { silent = true })

    -- 查看签名帮助
    vim.keymap.set({ 'n', 'i' }, '<A-/>', function()
        vim.fn.VSCodeNotify('editor.action.triggerParameterHints') -- 触发参数提示
    end, { silent = true })

    -- 补全相关快捷键
    vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
        vim.fn.VSCodeNotify('selectPrevSuggestion') -- 上一个补全项
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-Up>', function()
        vim.fn.VSCodeNotify('selectPrevSuggestion') -- 上一个补全项
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<Tab>', function()
        vim.fn.VSCodeNotify('selectNextSuggestion') -- 下一个补全项
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-Down>', function()
        vim.fn.VSCodeNotify('selectNextSuggestion') -- 下一个补全项
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-CR>', function()
        vim.fn.VSCodeNotify('acceptSelectedSuggestion') -- 确认补全（选择第一个）
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-/>', function()
        vim.fn.VSCodeNotify('editor.action.triggerSuggest') -- 触发补全
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-.>', function()
        vim.fn.VSCodeNotify('closeSuggestWidget') -- 关闭补全窗口
    end, { silent = true })

    -- 定义相关
    vim.keymap.set('n', 'gd', function()
        vim.fn.VSCodeNotify('editor.action.goToDeclaration') -- 转到定义（VS Code 中通常是转到定义）
    end, { silent = true, desc = "Goto Definition" })

    vim.keymap.set('n', 'gD', function()
        vim.fn.VSCodeNotify('editor.action.goToDeclaration') -- 转到声明（VS Code 中通常与定义相同）
    end, { silent = true, desc = "Goto Declaration" })

    -- 引用
    vim.keymap.set('n', 'gr', function()
        vim.fn.VSCodeNotify('editor.action.goToReferences') -- 查找引用
    end, { silent = true, desc = "References" })

    -- 实现
    vim.keymap.set('n', 'gI', function()
        vim.fn.VSCodeNotify('editor.action.goToImplementation') -- 转到实现
    end, { silent = true, desc = "Goto Implementation" })

    -- 类型定义
    vim.keymap.set('n', 'gy', function()
        vim.fn.VSCodeNotify('editor.action.goToTypeDefinition') -- 转到类型定义
    end, { silent = true, desc = "Goto Type Definition" })

    -- 诊断导航（错误跳转）
    vim.keymap.set('n', 'g[', function()
        vim.fn.VSCodeNotify('editor.action.marker.nextInFiles') -- 下一个错误/警告
    end, { silent = true, desc = "Goto Next Diagnostics" })

    vim.keymap.set('n', 'g]', function()
        vim.fn.VSCodeNotify('editor.action.marker.prevInFiles') -- 上一个错误/警告
    end, { silent = true, desc = "Goto Prev Diagnostics" })

    -- 符号相关
    vim.keymap.set('n', '<space>ss', function()
        vim.fn.VSCodeNotify('workbench.action.gotoSymbol') -- 转到文件中的符号
    end, { silent = true, desc = "LSP Symbols" })

    vim.keymap.set('n', '<space>sS', function()
        vim.fn.VSCodeNotify('workbench.action.showAllSymbols') -- 转到工作区中的符号
    end, { silent = true, desc = "LSP Workspace Symbols" })
end

return {
    {
        "neovim/nvim-lspconfig",
        cond = not vim.g.vscode,
        config = function()
            local lspconfig = require('lspconfig')
            local wk = require("which-key")
            local picker = require("snacks.picker")

            -- vim.api.nvim_create_autocmd("BufWritePost", {
            --     callback = function()
            --         if #vim.lsp.get_clients() > 0 then
            --             vim.lsp.buf.format()
            --         else
            --             vim.api.nvim_command('normal! mBgg=G\'B')
            --         end
            --     end
            -- })

            lspconfig.rust_analyzer.setup {}
            lspconfig.awk_ls.setup {}
            lspconfig.lua_ls.setup({
                on_init = function(client)
                    if client.workspace_folders and client.workspace_folders[1] then
                        local path = client.workspace_folders[1].name
                        -- vim.print(client.workspace_folders)
                        if path == os.getenv('HOME') .. '/.config/nvim' then
                            vim.opt.path:append(path .. '/lua')
                        end
                    end
                end,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace"
                        }
                    }
                }
            })
            lspconfig.ruff.setup {}
            lspconfig.pylsp.setup {}
            -- lspconfig.pyright.setup {
            --     single_file_support = false
            -- }

            lspconfig.clangd.setup {}
            -- lspconfig.asm_lsp.setup {}
            lspconfig.bashls.setup {}
            lspconfig.taplo.setup {}
            lspconfig.texlab.setup {}
            lspconfig.fish_lsp.setup {}
            lspconfig.tinymist.setup {}
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "typst",
                callback = function()
                    vim.bo.tabstop = 4
                    vim.bo.shiftwidth = 4
                    vim.bo.softtabstop = 4
                    vim.bo.expandtab = true
                end,
            })


            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-gfo>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    wk.add({
                        { "<space>f",  group = "alter code" },
                        { "<space>ff", vim.lsp.buf.format,                  desc = "format",               opts },
                        { "<space>fr", vim.lsp.buf.rename,                  desc = "rename",               opts },
                        { "<space>fa", vim.lsp.buf.code_action,             desc = "code action",          opts },
                        { "<space>w",  group = "workspace" },
                        { "<space>wa", vim.lsp.buf.add_workspace_folder,    desc = "add workspace folder", opts },
                        { "<space>wr", vim.lsp.buf.remove_workspace_folder, desc = "rm workspace folder",  opts },
                        {
                            "<space>wl",
                            function()
                                vim.print(vim.lsp.buf.list_workspace_folders())
                            end,
                            desc = "ls workspace folder",
                            opts
                        },
                    })
                    vim.keymap.set('n', '<C-k>', vim.diagnostic.open_float)

                    wk.add({
                        { "g",  group = "lsp" },
                        { "gt", picker.treesitter, desc = "types", opts },
                    })
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true })
                    vim.keymap.set({ "n", "i" }, '<A-/>', vim.lsp.buf.signature_help, { buffer = true })
                end,
            })
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
            local cmp = require('cmp')
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = cmp.config.sources(
                    {
                        { name = 'nvim_lsp' },
                        { name = 'vsnip' },
                    },
                    {
                        { name = 'buffer' },
                        { name = 'path' }
                    }
                ),
                -- 快捷键绑定
                mapping = {
                    -- 上一个
                    ['<S-tab>'] = cmp.mapping.select_prev_item(),
                    ['<C-Up>'] = cmp.mapping.select_prev_item(),
                    -- 下一个
                    ['<tab>'] = cmp.mapping.select_next_item(),
                    ['<C-Down>'] = cmp.mapping.select_next_item(),
                    -- 确认，如果没选择，取第一个
                    ['<C-CR>'] = cmp.mapping.confirm({
                        select = true, -- Set `select` to `false` to only confirm explicitly selected items.
                        behavior = cmp.ConfirmBehavior.Replace
                    }),
                    -- 出现补全
                    ['<C-/>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    -- 取消
                    ['<C-.>'] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                }
            }
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
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.yapf,
                    -- null_ls.builtins.completion.spell,
                    null_ls.builtins.formatting.shfmt,
                    null_ls.builtins.formatting.nginx_beautifier,
                    null_ls.builtins.formatting.prettier.with({
                        extra_args = { "--config", "/home/acd407/.config/prettierrc.json" }
                    }),
                    null_ls.builtins.formatting.typstyle.with({
                        extra_args = { "--tab-width", "4" }
                    }),
                },
            })
        end
    }
}
