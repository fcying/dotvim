local api = vim.api

api.nvim_create_augroup("myau", { clear = true })

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

-- project vimrc
vim.cmd([[
execute 'autocmd myau BufWritePost .pvimrc nested source ' . g:pvimrc_path
au myau SourcePost .pvimrc :lua require("util").update_ignore_config()
nnoremap <silent> <leader>ep  :execute 'e '  . g:pvimrc_path<CR>
]])
