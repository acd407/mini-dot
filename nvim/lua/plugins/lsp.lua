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
