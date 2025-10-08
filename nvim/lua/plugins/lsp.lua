if vim.g.vscode then
    -- 将重复的 VSCodeNotify 封装为局部函数
    local function notify(cmd, desc)
        return function()
            vim.fn.VSCodeNotify(cmd)
        end
    end

    -- 使用表驱动的方式定义键位映射
    local mappings = {
        -- 格式化相关
        ['<space>ff'] = { 'editor.action.formatDocument', 'Format document' },
        ['<space>fr'] = { 'editor.action.rename', 'Rename symbol' },
        ['<space>fa'] = { 'editor.action.quickFix', 'Quick fix' },

        -- 工作区相关
        ['<space>wa'] = { 'workbench.action.addRootFolder', 'Add workspace folder' },
        ['<space>wr'] = { 'workbench.action.removeRootFolder', 'Remove workspace folder' },
        ['<space>wl'] = { 'workbench.action.quickOpen', 'List workspace folders' },

        -- 诊断和悬停
        ['<C-k>'] = { 'editor.action.showHover', 'Show hover' },
        ['K'] = { 'editor.action.showHover', 'Show hover' },

        -- 定义和引用
        ['gd'] = { 'editor.action.goToDeclaration', 'Goto definition' },
        ['gD'] = { 'editor.action.goToDeclaration', 'Goto declaration' },
        ['gr'] = { 'editor.action.goToReferences', 'Find references' },
        ['gI'] = { 'editor.action.goToImplementation', 'Goto implementation' },
        ['gy'] = { 'editor.action.goToTypeDefinition', 'Goto type definition' },

        -- 诊断导航
        ['g['] = { 'editor.action.marker.nextInFiles', 'Next diagnostic' },
        ['g]'] = { 'editor.action.marker.prevInFiles', 'Previous diagnostic' },

        -- 符号相关
        ['<space>ss'] = { 'workbench.action.gotoSymbol', 'Document symbols' },
        ['<space>sS'] = { 'workbench.action.showAllSymbols', 'Workspace symbols' },

        -- 补全相关
        ['<S-Tab>'] = { 'selectPrevSuggestion', 'Previous suggestion' },
        ['<C-Up>'] = { 'selectPrevSuggestion', 'Previous suggestion' },
        ['<Tab>'] = { 'selectNextSuggestion', 'Next suggestion' },
        ['<C-/>'] = { 'editor.action.triggerSuggest', 'Trigger completion' },
        ['<C-.>'] = { 'closeSuggestWidget', 'Close completion' },

        -- 签名帮助
        ['<A-/>'] = { 'editor.action.triggerParameterHints', 'Signature help' },
    }

    -- 批量创建映射
    for key, mapping in pairs(mappings) do
        local modes = string.find(key, '<space>') and 'n' or
            (key == '<A-/>' or key:match('^<[CS]%-')) and { 'n', 'i' } or 'n'

        vim.keymap.set(modes, key, notify(mapping[1], mapping[2]), {
            silent = true,
            desc = mapping[2]
        })
    end
end

return {
    -- LSP 配置
    {
        "neovim/nvim-lspconfig",
        cond         = not vim.g.vscode,
        config       = function()
            require("config.lsp")
        end,
    },

    -- 补全系统 (将相关插件组织在一起)
    {
        "hrsh7th/nvim-cmp",
        cond = not vim.g.vscode,
        event = "InsertEnter", -- 延迟加载
        dependencies = {
            -- 补全源
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",

            -- 片段系统
            {
                "hrsh7th/cmp-vsnip",
                dependencies = {
                    "hrsh7th/vim-vsnip",
                    "rafamadriz/friendly-snippets",
                }
            }
        },
        config = function()
            local cmp = require('cmp')

            -- 补全源配置
            local sources = {
                { name = 'nvim_lsp' },
                { name = 'vsnip' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'lazydev', group_index = 0 },
            }

            -- 快捷键配置
            local mappings = {
                ['<S-tab>'] = cmp.mapping.select_prev_item(),
                ['<C-Up>'] = cmp.mapping.select_prev_item(),
                ['<tab>'] = cmp.mapping.select_next_item(),
                ['<C-Down>'] = cmp.mapping.select_next_item(),
                ['<C-CR>'] = cmp.mapping.confirm({
                    select = true,
                    behavior = cmp.ConfirmBehavior.Replace
                }),
                ['<C-/>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                ['<C-.>'] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
                ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            }

            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = cmp.config.sources(
                    { sources[1], sources[2] }, -- LSP 和片段
                    { sources[3], sources[4] }  -- 缓冲区和路径
                ),
                mapping = mappings,
                window = {
                    completion = {
                        border = 'rounded',
                        winhighlight = 'Normal:CmpPmenu,CursorLine:Visual,FloatBorder:FloatBorder',
                    },
                    documentation = {
                        border = 'rounded',
                        winhighlight = 'Normal:CmpDoc,FloatBorder:FloatBorder',
                    },
                }
            }
        end
    }
}
