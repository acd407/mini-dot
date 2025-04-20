require('onedark').setup {
    style = 'warm',
    transparent = true,
    lualine = {
        transparent = true,
    },
    highlights = {
        ["@comment"] = { fg = '#888888' },
        ["@lsp.type.comment"] = { fg = '#888888' },
    }
}
require('onedark').load()
