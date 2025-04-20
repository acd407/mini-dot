-- 使用 git ls-files 命令检查文件是否被 git 管理
local function is_git_managed(file)
    local handle = io.popen('git ls-files --error-unmatch ' .. file .. ' 2> /dev/null')
    local result
    if handle then
        result = handle:read("*a")
        handle:close()
    end
    return result ~= ''
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    callback = function()
        if is_git_managed(vim.fn.expand('%:p')) then
            vim.opt.signcolumn = "yes"
        else
            vim.opt.signcolumn = "no"
        end
    end
})
