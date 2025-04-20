local wk = require('which-key')
local lualine = require('lualine')

vim.g.floaterm_width = 0.75
vim.g.floaterm_height = 0.85
vim.cmd('autocmd User FloatermOpen hi FloatermBorder guifg=#b1b4b9')
vim.cmd('command! -nargs=1 Fterm FloatermNew <args>')


vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.cmd('startinsert')
    end
})

local cmdheight, relativenumber, signcolumn, foreground
vim.api.nvim_create_autocmd('TermEnter', {
    callback = function()
        if #vim.o.ft == 0 then
            ---@diagnostic disable-next-line: missing-parameter
            lualine.hide()
            cmdheight = vim.o.cmdheight
            relativenumber = vim.o.relativenumber
            signcolumn = vim.o.signcolumn
            vim.o.cmdheight = 0
            vim.o.relativenumber = false
            vim.o.signcolumn = "no"
            foreground = string.format(
                "#%06x",
                vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).fg
            )
            vim.api.nvim_set_hl(0, "Normal", { fg = "#EEEEEC" })
        end
    end
})
vim.api.nvim_create_autocmd('TermLeave', {
    callback = function()
        if #vim.o.ft == 0 then
            ---@diagnostic disable-next-line:missing-fields
            lualine.hide({ unhide = true })
            vim.o.cmdheight = cmdheight
            vim.o.relativenumber = relativenumber
            vim.o.signcolumn = signcolumn
            vim.api.nvim_set_hl(0, "Normal", { fg = foreground })
        end
    end
})

local function get_word()
    -- 使用 Vim 的 internal function `getcurpos` 来得到光标位置的单词
    local word = vim.api.nvim_eval("expand('<cword>')")
    vim.cmd("FloatermNew --autoclose=0 --title=translate speak " .. word)
end

wk.add({
    { "<space>t",  group = "terminal" },
    { "<space>ty", "<Cmd>FloatermNew yazi<CR>", desc = "yazi" },
    { "<space>tt", get_word,                    desc = "translate" },
})
