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

local setup_custom_hl = function()
    local fg_color = vim.g.terminal_color_15
    local bg_color = vim.g.terminal_color_0

    vim.api.nvim_set_hl(0, "Conceal", { bg = bg_color })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = fg_color })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = fg_color })
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
end
-- 已经错过设置主题的时机了，手动执行一次
setup_custom_hl()

if not vim.g.vscode then
    vim.api.nvim_create_autocmd("VimLeave", {
        callback = function()
            reset_cursor()
        end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "onedark",
        callback = setup_custom_hl,
    })
end

-- 删除行尾空格
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function()
--         local save = vim.fn.winsaveview() -- 保存光标位置
--         vim.cmd([[%s/\s\+$//e]])          -- 执行删除尾部空格的命令
--         vim.fn.winrestview(save)          -- 恢复光标位置
--     end,
-- })
