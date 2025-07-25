vim.g.copilot_enabled = false

vim.keymap.set('i', '<C-S-CR>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
