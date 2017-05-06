"git clone https://github.com/Shougo/dein.vim
set nocompatible

set guioptions=

let g:config_dir=$VIM
let g:plugin_dir = g:config_dir . '/plugged'
let g:plugin_manager_dir = g:plugin_dir . '/dein.vim'
exec 'set runtimepath+=' . g:plugin_manager_dir

if dein#load_state(expand(g:plugin_dir))
  call dein#begin(expand(g:plugin_dir))
  call dein#add(expand(g:plugin_manager_dir))
  call dein#add('Shougo/vimproc.vim', {'build' : 'Tools\update-dll-mingw.bat'})
  call dein#add('Shougo/denite.nvim')
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable


nnoremap <silent> ff :Denite file_rec<CR>

