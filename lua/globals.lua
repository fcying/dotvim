local g, opt, fn, api = vim.g, vim.opt, vim.fn, vim.api
local util = require("util")

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
g.root_marker = util.get_root_marker({ ".root", ".git", ".repo", ".svn" })

vim.cmd([[
let g:ignore_default = {
      \ 'dir':['.root','.svn','.git','.repo','.ccls-cache','.cache','.ccache'],
      \ 'file':['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]',
      \ 'GTAGS', 'GRTAGS', 'GPATH', 'prj_tag','tags'],
      \ 'mru':['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll'],
      \ 'rg':['--max-columns=300', '--iglob=!obj', '--iglob=!out']}
let g:ignore = {'dir':[], 'file':[], 'rg':[], 'mru':[]}
]])

if g.is_win == 1 then
    vim.env.PATH = g.config_dir .. "\\vendor" .. ";" .. vim.env.PATH
else
    vim.env.PATH = g.config_dir .. "/vendor" .. ":" .. vim.env.PATH
end

api.nvim_create_augroup("myau", { clear = true })

-- find user config {{{
if g.is_win == 1 then
    g.file_vimrc_local = os.getenv("USERPROFILE") .. "/.vimrc.local"
else
    g.file_vimrc_local = os.getenv("HOME") .. "/.vimrc.local"
end
if fn.filereadable(g.file_vimrc_local) == 1 then
    vim.cmd.source(g.file_vimrc_local)
end

if g.is_win == 1 then
    g.make = "mingw32-make"
else
    g.make = "make"
end

-- options {{{
opt.autochdir = false
opt.autoread = true
opt.autowrite = false
opt.backup = false
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.cinkeys = opt.cinkeys - "0#"
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.completeopt = "menu,menuone,noselect,noinsert"
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs

opt.fileencodings = "ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,euc-kr,latin1"
opt.formatoptions = opt.formatoptions + "mM" - "o"
--stop auto insert comment, set FileType can't work
api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    group = api.nvim_create_augroup("set_fo", { clear = true }),
    callback = function()
        vim.opt_local.formatoptions = vim.opt_local.formatoptions - "o"
    end,
})

if g.has_rg == 1 then
    opt.grepformat = "%f:%l:%c:%m"
    opt.grepprg = "rg --vimgrep"
end

opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 2
opt.list = false -- Show some invisible characters (tabs...
opt.mouse = "a"
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = false
opt.scrolloff = 3
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4
opt.shortmess:append({ W = false, I = false, c = true })
opt.showmode = false
opt.signcolumn = "auto"
opt.smartcase = true
opt.smartindent = true
opt.swapfile = false
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 500
opt.ttimeoutlen = 80
opt.undodir =  g.cache_dir .. "/undodir_nvim"
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "onemore" -- onemore all
opt.visualbell = false
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = true
opt.whichwrap = opt.whichwrap + "<,>,[,],h,l"

-- foldmethod {{{
opt.foldmethod = "manual"
opt.foldenable = false

-- ignore file in search && complete {{{
opt.suffixes = ".bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class"
opt.wildignore = "*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib"
opt.wildignore = opt.wildignore + "*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex"
opt.wildignore = opt.wildignore + "*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz"
opt.wildignore = opt.wildignore + "*DS_Store*,*.ipch"
opt.wildignore = opt.wildignore + "*.gem"
opt.wildignore = opt.wildignore + "*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso"
opt.wildignore = opt.wildignore + "*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**"
opt.wildignore = opt.wildignore + "*/.nx/**,*.app,*.git,.git"
opt.wildignore = opt.wildignore + "*.wav,*.mp3,*.ogg,*.pcm"
opt.wildignore = opt.wildignore + "*.mht,*.suo,*.sdf,*.jnlp"
opt.wildignore = opt.wildignore + "*.chm,*.epub,*.pdf,*.mobi,*.ttf"
opt.wildignore = opt.wildignore + "*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc"
opt.wildignore = opt.wildignore + "*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps"
opt.wildignore = opt.wildignore + "*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu"
opt.wildignore = opt.wildignore + "*.gba,*.sfc,*.078,*.nds,*.smd,*.smc"
opt.wildignore = opt.wildignore + "*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android"

if fn.has("nvim-0.9.0") == 1 then
    opt.splitkeep = "screen"
    opt.shortmess:append({ C = true })
end

-- filetype {{{
vim.cmd([[
autocmd myau FileType go setlocal noexpandtab nolist
autocmd myau FileType vim,json,jsonc,yaml,toml,dosbatch
    \ setlocal shiftwidth=2
    \ softtabstop=2
    \ tabstop=2
    \ expandtab
autocmd myau BufNewFile,BufRead *.conf setl filetype=conf
autocmd myau BufNewFile,BufRead *.json setl filetype=jsonc
autocmd myau BufNewFile,BufRead .tasks setl filetype=conf
autocmd myau BufNewFile,BufRead syslog setl filetype=messages
autocmd myau BufNewFile,BufRead rc.local setl filetype=sh

autocmd myau BufNewFile,BufRead gitconfig setl filetype=gitconfig
autocmd myau FileType gitconfig 
    \ setl noexpandtab
]])

-- close some filetypes with <q> {{{
vim.api.nvim_create_autocmd("FileType", {
    group = api.nvim_create_augroup("close_with_q", { clear = true }),
    pattern = {
        "help",
        "lspinfo",
        "man",
        "notify",
        "PlenaryTestPopup",
        "qf",
        "query", -- :InspectTree
        "spectre_panel",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- omnifunc use syntax {{{
vim.api.nvim_create_autocmd("BufEnter", {
    group = api.nvim_create_augroup("set_omnifunc", { clear = true }),
    pattern = { "*" },
    callback = function()
        vim.opt_local.omnifunc = "syntaxcomplete#Complete"
    end,
})

-- FIXME nvim not restore terminal cursorshape https://github.com/neovim/neovim/issues/4396 {{{
vim.api.nvim_create_autocmd("VimLeave", {
    group = api.nvim_create_augroup("set_cursorshape", { clear = true }),
    pattern = { "*" },
    callback = function()
        vim.cmd([[ set guicursor= | call chansend(v:stderr, "\x1b[ q") ]])
    end,
})

-- wsl clip {{{
--if g.is_wsl == 1 then
--    vim.cmd([[
--    let s:clip = '/mnt/c/Windows/System32/clip.exe'
--    if executable(s:clip)
--        augroup WSLYank
--        autocmd!
--        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
--        augroup END
--    endif
--    ]])
--end

-- large file {{{
vim.cmd([[
let g:LargeFile = 1024 * 1024 * 10
autocmd myau BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
function! LargeFile()
  "set binary
  setlocal eventignore+=FileType    "no syntax highlighting etc
  setlocal bufhidden=unload         "save memory when other file is viewed
  setlocal undolevels=-1            "no undo possible
  " display message
  autocmd myau VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see vim config for details)."
endfunction
]])
