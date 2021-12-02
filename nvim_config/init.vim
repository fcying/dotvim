" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :

" global var {{{
let g:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:cache_dir = g:config_dir . '/.cache'
let s:plug_install_dir = g:config_dir . '/plugged'
let g:file_vimrc = g:config_dir . '/init.vim'
let g:file_basic_config = g:config_dir . '/basic.vim'
let g:file_vimrc_local = $HOME .'/.vimrc.local'
if !exists('g:lsp_servers')
  let g:lsp_servers = ['clangd', 'vimls']
endif

if filereadable(g:file_basic_config)
  execute 'source ' . file_basic_config
else
  execute 'source ' . g:config_dir . '/../basic.vim'
endif


" plugins {{{
let s:plug_init = 0
let s:plug_manager_download =
      \ 'silent !git clone --depth 1 https://github.com/junegunn/vim-plug '
      \ . s:plug_install_dir . '/vim-plug'
let s:plug_manager_file = s:plug_install_dir . '/vim-plug/plug.vim'

if filereadable(expand(s:plug_manager_file)) == 0
  if executable('git')
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

exec 'source '. s:plug_install_dir . '/vim-plug/plug.vim'
call plug#begin(expand(s:plug_install_dir))
Plug 'junegunn/vim-plug'
Plug 'fcying/gen_clang_conf.vim'
Plug 'wsdjeg/vim-fetch'
Plug 'moll/vim-bbye'
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-expand-region'
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'mg979/vim-visual-multi'
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdcommenter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kevinhwang91/nvim-bqf', {'for':'qf'}
Plug 'mhinz/vim-grepper'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'quangnguyen30192/cmp-nvim-tags'
"Plug 'andersevenrud/compe-tmux', { 'branch': 'cmp' }
Plug 'joshdick/onedark.vim'
Plug 'lifepillar/vim-solarized8'
call plug#end()
delc PlugUpgrade

nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>
autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugUpdate --sync
      \| endif

function! HasPlug(name) abort
  if index(g:plugs_order, a:name) != -1
    if isdirectory(s:plug_install_dir . '/' . a:name)
      return 0
    endif
  endif
  "echom a:name
  return -1
endfunction

if s:plug_init ==# 1
  finish
endif


" plugin setting {{{
if filereadable(g:config_dir . '/config.vim')
  exec 'so ' . g:config_dir . '/config.vim'
else
  exec 'so ' . g:config_dir . '/../config.vim'
endif

if filereadable(g:config_dir . '/config.lua')
  exec 'luafile ' . g:config_dir . '/config.lua'
else
  exec 'luafile ' . g:config_dir . '/../config.lua'
endif

let g:colorscheme = get(g:, 'colorscheme', 'onedark')

if g:colorscheme == 'solarized8'
  colorscheme solarized8
  set background=light
  set termguicolors
else
  colorscheme onedark
  set background=dark
endif

if trim(execute(":color")) ==# 'solarized8'
  let g:lightline = { 'colorscheme': 'solarized' }
else
  let g:lightline = { 'colorscheme': 'wombat' }
endif

" post load vimrc config {{{
if exists('*LoadAfter')
  call LoadAfter()
endif
if exists('*LoadAfterProject')
  call LoadAfterProject()
endif

filetype plugin indent on
syntax enable

call UpdateIgnore()
