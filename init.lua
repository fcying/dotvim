local g, fn = vim.g, vim.fn

g.is_wsl = fn.isdirectory("/mnt/c")
g.is_win = fn.has("win32")
g.is_tmux = fn.exists("$TMUX")
g.dir_separator = g.is_win == 1 and "\\" or "/"
g.path_separator = g.is_win == 1 and ";" or ":"

-- set dir path {{{
g.config_dir = fn.fnamemodify(fn.resolve(fn.expand("<sfile>:p")), ":h")
vim.opt.rtp:prepend(g.config_dir)

g.etc_dir = g.config_dir .. g.dir_separator .. "etc"
g.runtime_dir = g.config_dir .. g.dir_separator .. ".run"
g.plugins_dir = g.runtime_dir .. g.dir_separator .. "plugins"

for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = g.runtime_dir .. g.dir_separator .. name
end

vim.env.PATH = g.config_dir .. g.dir_separator .. "vendor" .. g.path_separator .. vim.env.PATH
g.file_log = g.runtime_dir .. g.dir_separator .. "vim.log"

require("config").setup()
