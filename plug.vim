"let g:plug_manager = 'vim-plug'
let g:plug_manager = 'packer'
"let g:plug_manager = 'none'

if g:is_nvim ==# 0
  let g:plug_manager = 'vim-plug'
endif

let g:plug_names = {}
let g:plug_options = []
if !exists('g:plug_dir')
  let g:plug_dir = g:root_dir . '/.plugged'
endif
let s:plug_install_dir = g:plug_dir . '/pack/packer/opt'
let s:plug_init = 0
let s:plug_need_update = 0

" init env {{{
if g:plug_manager ==# 'packer'
  "for packer_compiled.lua
  exec 'set runtimepath^=' . g:plug_dir
  exec 'set packpath=' . g:plug_dir
  let s:plug_manager_file = s:plug_install_dir . '/packer.nvim/lua/packer.lua'
  let s:plug_manager_download =
        \ 'silent !git clone --depth 1 https://github.com/wbthomason/packer.nvim '
        \ . s:plug_install_dir . '/packer.nvim'
elseif g:plug_manager ==# 'vim-plug'
  let s:plug_manager_file = s:plug_install_dir . '/vim-plug/plug.vim'
  let s:plug_manager_download =
        \ 'silent !git clone --depth 1 https://github.com/junegunn/vim-plug '
        \ . s:plug_install_dir . '/vim-plug'
else
  "not plugin
  let g:plug_dir = g:root_dir
  let s:plug_manager_file = g:config_dir . '/basic.vim'
endif

" Bootstrapping {{{
if filereadable(expand(s:plug_manager_file)) == 0
  if executable('git')
    "if filereadable(expand(g:file_vimrc_local)) == 0
    "  call writefile([
    "        \ '"let g:complete_engine=''nvimlsp''',
    "        \ '"let g:colorscheme=''solarized8''',
    "        \ '"let g:background=''light''',
    "        \ 'function! LoadAfter()',
    "        \ 'endfunc',
    "        \ ], expand(g:file_vimrc_local), 'a')
    "endif
    exec s:plug_manager_download
    if filereadable(expand(s:plug_manager_file)) == 0
      echohl WarningMsg
      echom 'install plug manager failed!'
      echohl None
    else
      let s:plug_init = 1
    endif
  else
    echohl WarningMsg
    echom 'You need install git!'
    echohl None
  endif
endif

" find plugin {{{
function! HasPlug(name) abort
  if get(g:plug_names, a:name) ==# 1
    return 1
  endif
  return -1
endfunction

function! MyPlug(repo, ...)
  let l:plug = []
  let l:plug_name = fnamemodify(a:repo, ':t:s?\.git$??')

  " packer.nvim
  if g:plug_manager ==# 'packer'
    call add(l:plug, a:repo)
    let l:options = {}
    let l:options.opt = 'false'
    if a:0 != 0
      for key in keys(a:1)
        if key ==# 'keys' || key ==# 'ft' || key ==# 'cmd' || key ==# 'event'
              \ || key ==# 'fn' || key ==# 'after'
              \ || key ==# 'module' || key ==# 'module_pattern'
          let l:options.opt = 'true'
          exec 'let l:options.' . key . ' = a:1[key]'
        elseif key ==# 'run'
          exec 'let l:options.' . key . ' = string(a:1[key])'
        elseif key ==# 'rtp' || key ==# 'commit' || key ==# 'branch'
              \ || key ==# 'requires' || key ==# 'config'
          exec 'let l:options.' . key . ' = a:1[key]'
        endif
      endfor
    endif

    if isdirectory(s:plug_install_dir . '/' . l:plug_name)
      exec 'let g:plug_names[''' . l:plug_name . '''] = 1'
      if l:options.opt ==# 'false'
          exe 'packadd! '. l:plug_name
      endif
    else
      exec 'let g:plug_names[''' . l:plug_name . '''] = 0'
      let s:plug_need_update = 1
    endif
    call add(l:plug, l:options)
    call add(g:plug_options, l:plug)
    "echo l:plug

  elseif g:plug_manager ==# 'vim-plug'
    call add(l:plug, a:repo)
    if a:0 != 0
      let l:options = {}
      for key in keys(a:1)
        if key ==# 'cmd'
          exec "let l:options.on = a:1[key]"
        elseif key ==# 'run'
          exec "let l:options.do = a:1[key]"
        elseif key ==# 'branch'
          exec "let l:options.branch = a:1[key]"
        elseif key ==# 'ft'
          exec "let l:options.for = a:1[key]"
        endif
      endfor
      call add(l:plug, l:options)
    endif
    call add(g:plug_options, l:plug)
    if isdirectory(s:plug_install_dir . '/' . l:plug_name)
      exec 'let g:plug_names[''' . l:plug_name . '''] = 1'
    else
      exec 'let g:plug_names[''' . l:plug_name . '''] = 0'
      let s:plug_need_update = 1
    endif
  endif
endfunction
command! -nargs=+ -bar MyPlug call MyPlug(<args>)


" install function {{{
function! InstallLeaderF(info) abort
  if g:plug_manager ==# 'packer'
    if g:is_win
      exe 'silent !cd /d ' . s:plug_install_dir . '\LeaderF && .\install.bat'
    else
      exe 'silent !cd ' . s:plug_install_dir . '/LeaderF && ./install.sh'
    endif
  else
    if g:is_win
      silent !.\install.bat
    else
      silent !./install.sh
    endif
  endif
  silent !pip3 install pygments --upgrade
endfunction


function! MyPlugUpgrade()
  if g:plug_manager ==# 'packer'
    lua require('config').packer()

    nnoremap <leader>pu :PackerSync<CR>
    nnoremap <leader>pi :PackerInstall<CR>
    nnoremap <leader>pr :PackerClean<CR>
    nnoremap <leader>pc :PackerCompile<CR>

  elseif g:plug_manager ==# 'vim-plug'
    exec 'source '. s:plug_install_dir . '/vim-plug/plug.vim'
    call plug#begin(expand(s:plug_install_dir))
    Plug 'junegunn/vim-plug'

    for plug in g:plug_options
      if len(plug) ==# 2
        exec "Plug plug[0], plug[1]"
      else
        exec "Plug plug[0]"
      endif
    endfor

    call plug#end()
    delc PlugUpgrade
    nnoremap <leader>pu :PlugUpdate<CR>
    nnoremap <leader>pi :PlugInstall<CR>
    nnoremap <leader>pr :PlugClean<CR>
  endif

  execute 'source ' . g:config_dir . '/config.vim'
  call UpdateIgnore()
endfunction


" init plugin {{{
if s:plug_init ==# 1
  let g:colorscheme = 'default'
endif
autocmd myau VimEnter *
      \ if s:plug_need_update ==# 1
      \ |   call feedkeys("\<space>pu", "tx")
      \ | endif

