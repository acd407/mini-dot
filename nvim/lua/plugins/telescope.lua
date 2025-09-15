return {
    'nvim-telescope/telescope.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { "<space>st", require 'telescope.builtin'.tags, desc = "Smart Find CTags" },
    }
}
