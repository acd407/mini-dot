return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { "<space>st", require 'telescope.builtin'.tags, desc = "Smart Find CTags" },
    }
}
