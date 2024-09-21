-- vim.loader.enable()

vim.g.is_wsl = vim.fn.isdirectory("/mnt/c")
vim.g.is_win = vim.fn.has("win32")
vim.g.is_tmux = vim.fn.exists("$TMUX")
vim.g.dir_separator = vim.g.is_win == 1 and "\\" or "/"
vim.g.path_separator = vim.g.is_win == 1 and ";" or ":"

-- set dir path {{{
vim.g.config_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("<sfile>:p")), ":h")
vim.opt.rtp:prepend(vim.g.config_dir)
vim.g.runtime_dir = vim.g.config_dir .. vim.g.dir_separator .. ".run"

for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = vim.g.runtime_dir .. vim.g.dir_separator .. name
end

vim.env.PATH = vim.g.config_dir .. vim.g.dir_separator .. "vendor" .. vim.g.path_separator .. vim.env.PATH

local util = require("util")
util.get_root_marker({ ".root", ".git", ".repo", ".svn" })
require("project_config").setup()

-- solarized tokyonight-day everforest rose-pine-dawn
local colorscheme = vim.g.colorscheme or "solarized"
local background = vim.g.background or "light"
vim.opt.background = background

require("option")
require("keymap")
require("_lazy")

vim.cmd.colorscheme(colorscheme)
util.update_ignore_config()
