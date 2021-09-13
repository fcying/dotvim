" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :
set nocompatible

" global var {{{
let g:mapleader = ' '
let g:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:cache_dir = g:config_dir . '/.cache'
let g:file_vimrc_local = $HOME .'/.vimrc.local'
let g:file_vimrc = g:config_dir . '/init.vim'
let g:root_markers = ['.root', '.git', '.svn']
let g:scm_dir = ''

augroup myau
  autocmd!
augroup END

if !isdirectory(g:cache_dir)
  call mkdir(g:cache_dir)
endif

if filereadable(g:file_vimrc_local)
  execute 'source ' . g:file_vimrc_local
endif

" find project root dir
function! GetRootDir()
  for l:item in g:root_markers
    let l:dir = finddir(l:item, '.;')
    if !empty(l:dir)
      break
    endif
  endfor
  if !empty(l:dir)
    let g:scm_dir = fnamemodify(l:dir, ':p:h')
  else
    let g:scm_dir = getcwd()
  endif
endfunction
call GetRootDir()

" find project vimrc
let g:pvimrc_path = findfile('.pvimrc', g:scm_dir . ';' . g:scm_dir . '..')
if g:pvimrc_path !=# ''
  exec 'sandbox source ' . g:pvimrc_path
  "echom g:pvimrc_path
else
  let g:pvimrc_path = g:scm_dir . '/.pvimrc'
endif
nnoremap <silent> <leader>ep  :execute 'e '  . g:pvimrc_path<CR>
nnoremap <silent> <leader>evv :execute 'e '  . g:file_vimrc<CR>
nnoremap <silent> <leader>evl :execute 'e '  . g:file_vimrc_local<CR>

" disable beep {{{
set t_vb=
set visualbell
set noerrorbells

" encoding {{{
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,euc-kr,latin1
set fileformats=unix,dos,mac

" basic {{{
set mouse=nv
set clipboard+=unnamedplus
set autoindent
set smartindent
set cindent
set backspace=eol,start,indent
set wrap
set whichwrap+=<,>,[,],h,l
set ttimeout
set ttimeoutlen=50
set iskeyword -=.
" align #
set cinkeys-=0#
"inoremap # X#
"set iskeyword -=#
autocmd myau FileType * setlocal formatoptions-=o
set formatoptions+=mM
set virtualedit=onemore        "onemore all
set history=2000
set scrolloff=3
set hidden
set noautochdir
set updatetime=300

" backup {{{
set nobackup
set nowritebackup
set undofile
execute 'set undodir=' . g:cache_dir . '/undodir-nvim'
set noswapfile

" display
set cursorline
set showmatch
set matchtime=2
set number
set ruler
set laststatus=2
"set nolist
set list
"set listchars=tab:▸\ ,trail:.,nbsp:+,extends:❯,precedes:❮
set showcmd
set wildmenu
set wildmode=longest:full,full
set splitright
set splitbelow
if $TERM !=# "ansi"
  set lazyredraw  "vim-plug scripts update error: Vim: Error reading input, exiting
endif
set signcolumn=number

" search {{{
set magic
set incsearch
set hlsearch
set wrapscan    "search loop
set ignorecase
set smartcase
set inccommand=nosplit

" tab shift {{{
set expandtab        "retab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" quickfix {{{
au myau FileType qf setlocal nonumber
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m
function! ShowQuickfix()
  let l:winnr = winnr()
  rightbelow copen
  if l:winnr !=# winnr()
    wincmd p
  endif
endfunc
nnoremap <silent> <leader>co :call ShowQuickfix()<CR>
nnoremap <silent> <leader>cc :cclose<CR>
nnoremap <silent> <leader>cn :cnext<CR>
nnoremap <silent> <leader>cp :cprevious<CR>

" jump to the last position {{{
augroup vimStartup
  au!
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif

augroup END

" fast ident {{{
xnoremap < <gv
xnoremap > >gv|
nnoremap > >>_
nnoremap < <<_

" remap q Q {{{
nnoremap gQ Q
nnoremap Q q
nnoremap q <nop>

" tab {{{
function! s:tab_moveleft()
  let l:tabnr = tabpagenr() - 2
  if l:tabnr >= 0
    exec 'tabmove '.l:tabnr
  endif
endfunc
function! s:tab_moveright()
  let l:tabnr = tabpagenr() + 1
  if l:tabnr <= tabpagenr('$')
    exec 'tabmove '.l:tabnr
  endif
endfunc
command! -nargs=0 TabMoveRight call s:tab_moveright()
command! -nargs=0 TabMoveLeft call s:tab_moveleft()
noremap <silent> <leader>tc :tabnew<cr>
noremap <silent> <leader>tq :tabclose<cr>
noremap <silent> <leader>tn :tabnext<cr>
noremap <silent> <leader>tp :tabprev<cr>
noremap <silent> <leader>to :tabonly<cr>
noremap <silent><s-tab> :tabnext<CR>
inoremap <silent><s-tab> <ESC>:tabnext<CR>
noremap <silent><leader>1 :tabn 1<cr>
noremap <silent><leader>2 :tabn 2<cr>
noremap <silent><leader>3 :tabn 3<cr>
noremap <silent><leader>4 :tabn 4<cr>
noremap <silent><leader>5 :tabn 5<cr>
noremap <silent><leader>6 :tabn 6<cr>
noremap <silent><leader>7 :tabn 7<cr>
noremap <silent><leader>8 :tabn 8<cr>
noremap <silent><leader>9 :tabn 9<cr>
noremap <silent><leader>0 :tabn 10<cr>

" delete space, ^M, ansi escape codes {{{
nnoremap <leader>ds :%s/\s\+$//g<CR>:noh<CR>
nnoremap <leader>dm :%s/\r$//g<CR>:noh<CR>
nnoremap <leader>da :%s/\%x1b\[[0-9;]*m//g<CR>:noh<CR>

" virtual mode search {{{
function! VisualSelection() abort
  try
    let reg_save = @"
    noautocmd silent! normal! gvy
    return @"
  finally
    let @" = reg_save
  endtry
endfunction
xnoremap * <ESC>/\V<C-R>=escape(VisualSelection(), '/\')<CR><CR>
xnoremap # <ESC>?\V<C-R>=escape(VisualSelection(), '?\')<CR><CR>

" auto pairs  {{{
inoremap {<CR> {<CR>}<c-o><s-o>
inoremap } <c-r>=ClosePair('}')<CR>
function! CloseSamePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    let l:char=a:char . a:char . "\<Left>"
    return l:char
  endif
endf
function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endfunction

" completion {{{
set completeopt=menuone,noselect
set shortmess+=c
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"

" paste without overwrite register {{{
xnoremap p "_dP


" plugins {{{
let g:plug_dir = g:config_dir . '/plugged'
let s:plug_init = 0
let s:plug_manager_download =
      \ 'silent !git clone --depth 1 https://github.com/junegunn/vim-plug '
      \ . g:plug_dir . '/vim-plug'
let s:plug_manager_file = g:plug_dir . '/vim-plug/plug.vim'

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

exec 'source '. g:plug_dir . '/vim-plug/plug.vim'
call plug#begin(expand(g:plug_dir))
Plug 'junegunn/vim-plug'
Plug 'moll/vim-bbye'
Plug 'easymotion/vim-easymotion'
Plug 'fcying/gen_clang_conf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'lifepillar/vim-solarized8'
call plug#end()
delc PlugUpgrade

nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>
autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugUpdate --sync | q
      \| endif



" tags path cscope gtags {{{
set tags=tags,tags;
set cscopetag
if executable('gtags')
  set cscopeprg='gtags-cscope'
endif
set cscopequickfix=s+,c+,d+,i+,t+,e+,a+
func! Removetags()
  ClearClangConf
endf
func! Gentags()
  silent GenClangConf

  if executable('ctags')
    silent !ctags -R --c++-kinds=+p --fields=+iaS --language-force=C++
  endif
endf
nnoremap <silent> tg :call Gentags()<CR>
nnoremap <silent> tc :call Removetags()<CR>

if s:plug_init ==# 1
  finish
endif


" plugins======================================================================
" easymotion {{{
let g:EasyMotion_smartcase = 0
let g:EasyMotion_do_mapping = 0   " Disable default mappings
" move to {char}
nmap s <Plug>(easymotion-overwin-f)
" move to {char}{char}
nmap S <Plug>(easymotion-overwin-f2)
" Move to line
nmap L <Plug>(easymotion-overwin-line)


" vim-bbye {{{
nnoremap <Leader>q :Bdelete<CR>


" telescope {{{
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap f/ <cmd>Telescope live_grep<cr>
nnoremap fb <cmd>Telescope buffers<cr>
nnoremap fh <cmd>Telescope help_tags<cr>
nnoremap ft <cmd>Telescope tags<cr>
nnoremap ts <cmd>Telescope tags<cr>


" nvim-compe {{{
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true
let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.luasnip = v:true
let g:compe.source.emoji = v:true
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

exec 'luafile ' . g:config_dir . '/config.lua'

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

