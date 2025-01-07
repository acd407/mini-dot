require("nvim-treesitter.configs").setup({
    auto_install = true,
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }
        extended_mode = true,
        max_file_lines = nil,
    },
    autotag = { enable = true },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    autopairs = { enable = true },
})
