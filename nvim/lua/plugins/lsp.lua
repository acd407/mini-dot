local lspconfig = require('lspconfig')
local wk = require("which-key")
local builtin = require("telescope.builtin")

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
lspconfig.bashls.setup {}
lspconfig.taplo.setup {}
lspconfig.texlab.setup {}
lspconfig.fish_lsp.setup {}

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
            { "<space>rn", vim.lsp.buf.rename,                  desc = "rename",               opts },
            { "<space>ca", vim.lsp.buf.code_action,             desc = "code action",          opts },
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
            { "<space>d",  group = "diagnostic" },
            { "<space>dN", vim.diagnostic.goto_prev, desc = "goto prev" },
            { "<space>dn", vim.diagnostic.goto_next, desc = "goto next" },
            { "<space>dd", builtin.diagnostics,      desc = "list" },
        })
        vim.keymap.set('n', '<C-k>', vim.diagnostic.open_float)

        wk.add({
            { "g",  group = "lsp" },
            { "gD", builtin.lsp_type_definitions,          desc = "type definitions", opts },
            { "gd", builtin.lsp_definitions,               desc = "definition",       opts },
            { "gi", builtin.lsp_implementations,           desc = "implementation",   opts },
            { "gr", builtin.lsp_references,                desc = "references",       opts },
            { "gt", builtin.treesitter,                    desc = "types",            opts },
            { "gs", builtin.grep_string,                   desc = "strings",          opts },
            { "gS", builtin.lsp_dynamic_workspace_symbols, desc = "symbols",          opts },
            {
                "ff",
                function()
                    vim.lsp.buf.format { async = true }
                end,
                desc = "format",
                opts
            },
        })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true })
        vim.keymap.set({ "n", "i" }, '<A-/>', vim.lsp.buf.signature_help, { buffer = true })
    end,
})
