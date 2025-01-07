vim.api.nvim_create_user_command(
    'Erc',
    function()
        vim.cmd('edit ' .. vim.fn.stdpath('config') .. '/init.lua')
    end,
    { desc = 'open config file' }
)
