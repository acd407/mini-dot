local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.yapf,
        -- null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.nginx_beautifier,
        null_ls.builtins.formatting.prettier,
    },
})
