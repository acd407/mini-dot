local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
        },
        {
            { name = 'buffer' },
            { name = 'path' }
        }
    ),
    -- 快捷键绑定
    mapping = {
        -- 上一个
        ['<S-tab>'] = cmp.mapping.select_prev_item(),
        ['<C-Up>'] = cmp.mapping.select_prev_item(),
        -- 下一个
        ['<tab>'] = cmp.mapping.select_next_item(),
        ['<C-Down>'] = cmp.mapping.select_next_item(),
        -- 确认，如果没选择，取第一个
        ['<C-CR>'] = cmp.mapping.confirm({
            select = true, -- Set `select` to `false` to only confirm explicitly selected items.
            behavior = cmp.ConfirmBehavior.Replace
        }),
        -- 出现补全
        ['<C-/>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- 取消
        ['<C-.>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    }
}
