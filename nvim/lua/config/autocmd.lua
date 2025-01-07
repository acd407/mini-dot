-- 退出 VIM 时恢复光标

local reset_cursor = function()
    vim.opt.guicursor = ""
    local clear_str = ""
    if os.getenv("TERM") == "linux" then
        clear_str = "\x1b[?0c"
    else
        clear_str = "\x1b[0 q"
    end
    vim.api.nvim_chan_send(vim.v.stderr, clear_str)
end

vim.api.nvim_create_autocmd({ "VimLeave" }, {
    callback = function()
        reset_cursor()
    end,
})

-- 删除行尾空格
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save = vim.fn.winsaveview() -- 保存光标位置
        vim.cmd([[%s/\s\+$//e]])          -- 执行删除尾部空格的命令
        vim.fn.winrestview(save)          -- 恢复光标位置
    end,
})
