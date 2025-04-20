-- 有独立配置文件的在自己里面配置，其它的和公用的在这个文件

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- vim.api.nvim_set_keymap("n", "<C-X>", "<Cmd>Ex<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-Up>", "5k", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-Down>", "5j", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-Up>", "5k")
vim.keymap.set({ "n", "v" }, "<C-Down>", "5j")

-- TabPage
-- use alt to move from window
for i = 1, 9 do
    vim.api.nvim_set_keymap(
        "n",
        ("<A-%s>"):format(i),
        -- ("<Cmd>tabn %s<CR>"):format(i),
        ("<Cmd>tabnext %s<CR>"):format(i),
        { silent = true }
    )
end
