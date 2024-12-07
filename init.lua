vim.g.is_wsl = vim.fn.isdirectory("/mnt/c")
vim.g.is_win = vim.fn.has("win32")
vim.g.is_tmux = vim.fn.exists("$TMUX")
vim.g.path_separator = vim.g.is_win == 1 and "\\" or "/"

---@return string
function _G.join_paths(...)
    local result = table.concat({ ... }, vim.g.path_separator)
    return result
end

-- set dir path {{{
vim.g.config_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("<sfile>:p")), ":h")
vim.opt.rtp:prepend(vim.g.config_dir)
vim.g.runtime_dir = join_paths(vim.g.config_dir, ".run")

local env_separator = vim.g.is_win == 1 and ";" or ":"
vim.env.PATH = join_paths(vim.g.config_dir, "vendor") .. env_separator .. vim.env.PATH

---@diagnostic disable-next-line: duplicate-set-field
vim.fn.stdpath = function(what)
    if vim.tbl_contains({ "config", "data", "state", "cache", "log" }, what) then
        return join_paths(vim.g.runtime_dir, what)
    end
    print(what)
    return vim.call("stdpath", what)
end
vim.o.shadafile = join_paths(vim.g.runtime_dir, "state", "shadafile")

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
