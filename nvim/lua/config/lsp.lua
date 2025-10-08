local wk = require("which-key")

-- 自定义LSP服务器配置
vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders and client.workspace_folders[1] then
            local path = client.workspace_folders[1].name
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

-- 启用 lsp
for _, server in ipairs({
    'rust_analyzer', 'awk_ls', 'lua_ls', 'ruff',
    'pyright', 'clangd', 'bashls', 'taplo',
    'texlab', 'fish_lsp', 'tinymist', 'nginx_language_server',
    'cssls', 'eslint', 'html', 'jsonls'
}) do
    vim.lsp.enable(server)
end

-- LSP附着时的按键映射
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        wk.add({
            { "<space>f",  group = "alter code" },
            { "<space>ff", vim.lsp.buf.format,      desc = "format",      opts },
            { "<space>fr", vim.lsp.buf.rename,      desc = "rename",      opts },
            { "<space>fa", vim.lsp.buf.code_action, desc = "code action", opts },

            {
                "g[",
                function()
                    vim.diagnostic.jump({ count = 1, float = { border = 'rounded' } })
                end,
                desc = "Goto Next Diagnostics",
                opts
            },
            {
                "g]",
                function()
                    vim.diagnostic.jump({ count = -1, float = { border = 'rounded' } })
                end,
                desc = "Goto Prev Diagnostics",
                opts
            },
            { "gd",        function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition",        opts },
            { "gD",        function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration",       opts },
            { "gr",        function() Snacks.picker.lsp_references() end,        nowait = true,                   desc = "References", opts },
            { "gI",        function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation",    opts },
            { "gy",        function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition", opts },

            { "<space>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols",            opts },
            { "<space>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols",  opts },
            { "<space>sd", function() Snacks.picker.diagnostics() end,           desc = "Diagnostics",            opts },
            { "<space>sD", function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics",     opts },

            { "<space>w",  group = "workspace" },
            { "<space>wa", vim.lsp.buf.add_workspace_folder,                     desc = "add workspace folder",   opts },
            { "<space>wr", vim.lsp.buf.remove_workspace_folder,                  desc = "rm workspace folder",    opts },
            {
                "<space>wl",
                function()
                    vim.print(vim.lsp.buf.list_workspace_folders())
                end,
                desc = "ls workspace folder",
                opts
            },
        })
        vim.keymap.set('n', '<C-k>', function()
            vim.diagnostic.open_float({ border = 'rounded' })
        end, { buffer = true })
        vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover({ border = 'rounded' })
        end, { buffer = true })
        vim.keymap.set({ "n", "i" }, '<A-/>', function()
            vim.lsp.buf.signature_help({ border = 'rounded' })
        end, { buffer = true })
    end,
})
