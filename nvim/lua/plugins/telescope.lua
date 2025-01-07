local wk = require("which-key")
local builtin = require("telescope.builtin")
wk.add({
    { "<space>f",  group = "telescope" },
    { '<space>fl', builtin.builtin,      desc = 'selector' },

    { '<space>ff', builtin.find_files,   desc = 'find files' },
    { '<space>fF', builtin.git_files,    desc = 'git files' },
    { '<space>fg', builtin.live_grep,    desc = 'live grep' },
    { '<space>ft', builtin.tags,         desc = 'tags' },

    { '<space>fh', builtin.help_tags,    desc = 'help tags' },
    { '<space>fp', builtin.man_pages,    desc = 'manpages' },
    { '<space>fb', builtin.buffers,      desc = 'buffers' },
    { '<space>fm', builtin.marks,        desc = 'marks' },
    { '<space>fj', builtin.jumplist,     desc = 'jumplist' },
    { '<space>fa', builtin.autocommands, desc = 'autocommands' },
    { '<space>fk', builtin.keymaps,      desc = 'keymaps' }
})
