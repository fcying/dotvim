" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :

" global var {{{
let g:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:cache_dir = g:config_dir . '/.cache'
let s:plug_install_dir = g:config_dir . '/plugged'
let g:file_vimrc = g:config_dir . '/init.vim'
let g:file_basic_config = g:config_dir . '/basic.vim'
let g:file_vimrc_local = $HOME .'/.vimrc.local'
let g:root_markers = ['.root', '.git', '.svn']
let g:root_marker = ''
let g:mapleader = ' '

"let g:python3_host_prog = g:config_dir . '/venv/bin/python3'

if filereadable(g:file_basic_config)
  execute 'source ' . g:config_dir . '/basic.vim'
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
Plug 'easymotion/vim-easymotion'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
"Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'joshdick/onedark.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'quangnguyen30192/cmp-nvim-tags'
"Plug 'andersevenrud/compe-tmux', { 'branch': 'cmp' }
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
if (HasPlug('gen_clang_conf.vim') != -1) "{{{
  let g:gencconf_storein_rootmarker = get(g:,'gencconf_storein_rootmarker',1)
endif "}}}

if (HasPlug('LeaderF') != -1) "{{{
  let g:Lf_ShowDevIcons = 0
  let g:Lf_ShowHidden = 1
  let g:Lf_HideHelp = 1
  let g:Lf_DefaultMode = 'FullPath'
  let g:Lf_UseCache = 0
  let g:Lf_PreviewCode = 0
  let g:Lf_WorkingDirectoryMode = 'c'
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_JumpToExistingWindow = 0
  let g:Lf_CacheDirectory = g:cache_dir
  let g:Lf_RootMarkers = ['.root', '.git', '.svn']
  if g:is_win ==# 0
    let g:Lf_Ctags = 'ctags 2>/dev/null'
  endif

  let g:Lf_PreviewInPopup = 1
  "let g:Lf_WindowPosition = 'popup'
  "let g:Lf_PreviewHorizontalPosition = 'right'

  let g:Lf_CommandMap = {
        \ '<F5>': ['<C-L>'],
        \ }
  let g:Lf_NormalMap = {
        \ '_':        [['<C-j>', 'j'],
        \              ['<C-k>', 'k'],
        \             ],
        \ 'File':     [['<ESC>', ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
        \ 'Buffer':   [['<ESC>', ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
        \ 'BufTag':   [['<ESC>', ':exec g:Lf_py "bufTagExplManager.quit()"<CR>']],
        \ 'Mru':      [['<ESC>', ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
        \ 'Line':     [['<ESC>', ':exec g:Lf_py "lineExplManager.quit()"<CR>']],
        \ 'Function': [['<ESC>', ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
        \ 'Tag':      [['<ESC>', ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
        \ 'Rg':       [['<ESC>', ':exec g:Lf_py "rgExplManager.quit()"<CR>']],
        \ 'Gtags':    [['<ESC>', ':exec g:Lf_py "gtagsExplManager.quit()"<CR>']],
        \ }

  let g:Lf_PreviewResult = {
        \ 'File': 0,
        \ 'Buffer': 0,
        \ 'Mru': 0,
        \ 'Tag': 0,
        \ 'BufTag': 0,
        \ 'Function': 0,
        \ 'Line': 0,
        \ 'Colorscheme': 0,
        \ 'Rg': 0,
        \ 'Gtags': 0
        \}

  let g:Lf_ShortcutF = ''
  let g:Lf_ShortcutB = ''
  nnoremap ff :<C-u>Leaderf file --fullPath<CR>
  nnoremap fb :<C-u>Leaderf buffer --fullPath<CR>
  nnoremap fo :<C-u>Leaderf function --fullPath<CR>
  nnoremap fm :<C-u>Leaderf mru --fullPath<CR>
  nnoremap fl :<C-u>Leaderf line --fuzzy<CR>
  nnoremap ft :<C-u>Leaderf tag --fuzzy<CR>
  nnoremap fh :<C-u>Leaderf help --fuzzy<CR>
  nnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w %s", expand("<cword>"))<CR>
  nnoremap fG :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w ")<CR>
  xnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -F %s", leaderf#Rg#visual())<CR>
  nnoremap fr :<C-U>Leaderf --recall<CR><TAB>
  nnoremap f/ :<C-U>Leaderf rg<CR>
  nnoremap fj :<C-U>Leaderf jumps<CR>

  nnoremap fi :exec "Leaderf file --fullPath --input " . <SID>strip_include(getline("."))<CR>
  function! s:strip_include(line)
    let l:strip_include = substitute(a:line, '\v.*[\<"]([a-zA-Z0-9_/\.]+)[\>"]', '\1', 'g')
    return l:strip_include
  endfunction
endif "}}}

if (HasPlug('vim-easymotion') != -1) "{{{
  let g:EasyMotion_smartcase = 0
  let g:EasyMotion_do_mapping = 0   " Disable default mappings
  " move to {char}
  nmap s <Plug>(easymotion-overwin-f)
  " move to {char}{char}
  nmap S <Plug>(easymotion-overwin-f2)
  " Move to line
  nmap L <Plug>(easymotion-overwin-line)
  " Move to word
  "nmap <Leader>w <Plug>(easymotion-overwin-w)
endif "}}}

if (HasPlug('vim-bbye') != -1) "{{{
  nnoremap <Leader>q :Bdelete<CR>
endif "}}}

if (HasPlug('vim-vsnip') != -1) "{{{
  let g:vsnip_snippet_dir = g:config_dir . '/snippets'
  imap <expr> <c-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-j>'
  smap <expr> <c-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-j>'
  imap <expr> <c-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-k>'
  smap <expr> <c-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-k>'
endif "}}}

if filereadable(g:config_dir . '/config.lua')
  exec 'luafile ' . g:config_dir . '/config.lua'
else
  exec 'luafile ' . g:config_dir . '/../config.lua'
endif

set termguicolors

"colorscheme onedark
colorscheme solarized8
"set background=dark
set background=light

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
