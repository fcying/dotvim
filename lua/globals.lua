local g, fn = vim.g, vim.fn

g.mapleader = " "
g.maplocalleader = " "

g.etc_dir = g.config_dir .. "/etc"

g.cache_dir = g.config_dir .. "/.cache"
if fn.isdirectory(g.cache_dir) == 0 then
    fn.mkdir(g.cache_dir, "p")
end

g.file_log = g.cache_dir .. "/vim.log"

g.is_wsl = fn.isdirectory("/mnt/c")
g.is_win = fn.has("win32")
g.is_tmux = fn.exists("$TMUX")

g.has_rg = fn.executable("rg")
g.has_go = fn.executable("go")

g.ctags_opt = "--options=" .. g.config_dir .. "/etc/ctags"
g.lsp_ignore = {}
g.root_marker = require("util").get_root_marker({ ".root", ".git", ".repo", ".svn" })

vim.cmd([[
let g:ignore_default = {
      \ 'dir':['.root','.svn','.git','.repo','.ccls-cache','.cache','.ccache'],
      \ 'file':['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]',
      \ 'GTAGS', 'GRTAGS', 'GPATH', 'prj_tag','tag'],
      \ 'mru':['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll'],
      \ 'rg':['--max-columns=300', '--iglob=!obj', '--iglob=!out']}
let g:ignore = {'dir':[], 'file':[], 'rg':[], 'mru':[]}
]])

if g.is_win == 1 then
    vim.env.PATH = g.config_dir .. "\\vendor" .. ";" .. vim.env.PATH
else
    vim.env.PATH = g.config_dir .. "/vendor" .. ":" .. vim.env.PATH
end

-- find user config {{{
if g.is_win == 1 then
    g.file_vimrc_local = os.getenv("USERPROFILE") .. "/.vimrc.local"
else
    g.file_vimrc_local = os.getenv("HOME") .. "/.vimrc.local"
end
if fn.filereadable(g.file_vimrc_local) then
    vim.cmd.source(g.file_vimrc_local)
end

if g.is_win == 1 then
    g.make = "mingw32-make"
else
    g.make = "make"
end
