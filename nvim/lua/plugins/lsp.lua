return {
    {
        "neovim/nvim-lspconfig",
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
