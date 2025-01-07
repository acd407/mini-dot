if os.getenv("XDG_SESSION_TYPE") ~= "tty" then
    local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
    }

    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#7d3d44" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#846f48" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#335c7e" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#826241" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#5e794b" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#734680" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#38757d" })
    end)

    require("ibl").setup {
        indent = { highlight = highlight, char = "▏" },
        whitespace = {
            highlight = highlight,
            remove_blankline_trail = false,
        },
        scope = { enabled = false },
    }
end
