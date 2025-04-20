local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.yapf,
        -- null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.nginx_beautifier,
        null_ls.builtins.formatting.prettier.with({
            extra_args = { "--config", "/home/acd407/.config/prettierrc.json" }
        }),
        null_ls.builtins.formatting.typstyle.with({
            extra_args = { "--tab-width", "4" }
        }),
    },
})
