if os.getenv("XDG_SESSION_TYPE") ~= "tty" then
    local lualine = require('lualine')

    lualine.setup {
        options = {
            theme = 'onedark',
        },
        extensions = {
            'nvim-dap-ui',
            'lazy',
            'man',
            {
                sections = {
                    lualine_a = { function()
                        return "FILES"
                    end }
                },
                filetypes = { 'NvimTree' },
            }
        },
    }
end
