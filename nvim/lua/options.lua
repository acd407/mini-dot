-- UFT8
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "utf-8"

-- 禁止Neovim自动生成备份文件
vim.opt.backup = false

-- 显示命令行渐入的命令
vim.opt.showcmd = true

-- 每个分割窗口都有单独的状态行
-- vim.opt.laststatus = 2

-- 设置命令行高度为 1
vim.opt.cmdheight = 1

-- 行号
-- vim.opt.relativenumber = true
vim.opt.number = true

-- 终端标题
vim.opt.title = true

-- 缩进
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
-- Vim 将根据当前上下文自动使用空格和制表符的混合进行缩进。
vim.opt.smarttab = true
-- 80 列限制
vim.opt.colorcolumn = "81"
-- 在 Vim 中显示换行线的可视指示
vim.opt.breakindent = true
-- 自动缩进
vim.opt.ai = true
-- 智能缩进
vim.opt.si = true

-- 不换行
vim.opt.wrap = true
-- 光标行
-- vim.opt.cursorline = true
-- 光标以上和以下保持的最小屏幕行数
vim.opt.scrolloff = 10

-- mode 指示
vim.opt.showmode = false

-- 启用鼠标
vim.opt.mouse = ""

-- 拷贝
vim.opt.clipboard:append("unnamedplus")

-- 默认新窗口右和下
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 搜索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 在终端中使用真彩色
vim.opt.termguicolors = true

-- 有补全选项时，将显示一个带有可用选择的弹出菜单
vim.opt.wildoptions = "pum"

-- 背景颜色方案设置为"dark"，插件、颜色和语法高亮将针对暗背景进行优化。
vim.opt.background = "dark"

-- 允许读取工作区配置
vim.o.exrc = true

vim.g.terminal_color_0 = "#303030"
vim.g.terminal_color_1 = "#DB0000"
vim.g.terminal_color_2 = "#60BD07"
vim.g.terminal_color_3 = "#CFA900"
vim.g.terminal_color_4 = "#3C74BD"
vim.g.terminal_color_5 = "#94659C"
vim.g.terminal_color_6 = "#06989A"
vim.g.terminal_color_7 = "#D3D7CF"
vim.g.terminal_color_8 = "#4A4842"
vim.g.terminal_color_9 = "#EF2929"
vim.g.terminal_color_10 = "#8AE234"
vim.g.terminal_color_11 = "#FCE94F"
vim.g.terminal_color_12 = "#729FCF"
vim.g.terminal_color_13 = "#AD7FA8"
vim.g.terminal_color_14 = "#34E2E2"
vim.g.terminal_color_15 = "#EEEEEC"

vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#D3D7CF" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#D3D7CF" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#D3D7CF" })
