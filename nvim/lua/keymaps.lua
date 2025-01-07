-- 有独立配置文件的在自己里面配置，其它的和公用的在这个文件

-- ---------- 视觉模式 ----------
-- 单行或多行移动
-- vim.api.nvim_set_keymap 是原生函数
vim.api.nvim_set_keymap("v", "K", "<Cmd>m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", "<Cmd>m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<S-Up>", "<Cmd>m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<S-Down>", "<Cmd>m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- vim.api.nvim_set_keymap("n", "<C-X>", "<Cmd>Ex<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Up>", "5k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", "5j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Up>", "<C-y>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Down>", "<C-e>", { noremap = true, silent = true })

-- nohl
vim.api.nvim_set_keymap("n", "<space>nh", "<Cmd>nohl<CR>", { noremap = true, silent = true })

-- buffer
-- vim.api.nvim_set_keymap("n", "<C-p>", "<Cmd>bprevious<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-n>", "<Cmd>bnext<CR>", { noremap = true, silent = true })

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

-- Window
vim.api.nvim_set_keymap("n", "<A-Left>", "<C-W>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-Right>", "<C-W>l", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-Up>", "<C-W>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-Down>", "<C-W>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-=>", "<C-W>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-->", "<C-W>-", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-,>", "<C-W><", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-.>", "<C-W>>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-q>", "<Cmd>close<CR>", { noremap = true, silent = true })
