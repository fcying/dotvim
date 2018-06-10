"check environment {{{
if &compatible
  set nocompatible
endif    

let g:is_osx = has('macunix')
let g:is_lin = has('unix') && !has('macunix') && !has('win32unix')
let g:is_win = has('win32')
let g:is_nvim = has('nvim')
let g:is_vim8 = has('patch-8.0.0039') && exists('*job_start')
let g:has_go = executable('go') ? 1 : 0
let s:is_gui = has('gui_running')

let g:config_dir = expand('<sfile>:p:h')
let g:file_plug = g:config_dir . '/plug.vim'

"}}}



" ============================================================================
" basic settings {{{
" ============================================================================
if filereadable($HOME . '/.vimrc.pre')
  execute 'source ' . $HOME .'/.vimrc.pre'
endif

let g:mapleader = get(g:,'mapleader',';')

augroup fcying_au
  autocmd!
augroup END


" add plugin
if filereadable(g:file_plug)
  execute 'source ' . g:file_plug
endif
filetype plugin indent on
syntax enable


"autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>ep :execute 'e ' . g:file_plug<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ez :e ~/.zshrc<CR>

if g:is_nvim ==# 0
  if g:is_win
    set renderoptions=type:directx,level:0.50,
          \gamma:1.0,contrast:0.0,geom:1,renmode:5,taamode:1
  else
    set clipboard=exclude:.*    "setup clipboard make startup slow
  endif
else
  set guicursor=
endif

if s:is_gui
  set guioptions -=T
  set guioptions -=m
  set mouse=a
  set guifont=Consolas:h11
  autocmd fcying_au GUIEnter * simalt ~x
else
  set mouse=nv
endif
if &term =~# '^screen'
  " tmux knows the extended mouse mode
  set ttymouse=xterm2
endif
"close beep
set visualbell t_vb=       
set novisualbell
set noerrorbells
autocmd fcying_au VimEnter * set shellredir=>
set ttyfast     " when will this cause problems?

let $LANG='en' "zh-cn gina work error
set encoding=utf-8
scriptencoding utf-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
if g:is_win
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif

set history=2000
"set autoread
set updatetime=1000
set scrolloff=3
set hidden
set noswapfile
set nobackup
set nowritebackup
set splitright
set splitbelow
set noautochdir
set regexpengine=1        " use old re, for speed syntax 

set wildmenu
set wildmode=longest:full,full
set wildignore=*.bak,*.o,*.e,*.swp,.git,.svn,*.pyc,*.class

"set cursorcolumn
set cursorline

set magic
set incsearch
set hlsearch
set wrapscan    "search loop
set ignorecase
set smartcase
set path+=../inc,../src,
if g:is_win
  let $PATH = g:config_dir . '\lib' . ';' . $PATH
elseif g:is_lin
  let $PATH = g:config_dir . '/lib' . ':' . $PATH
endif

set expandtab        "%retab
set tabstop=4
set shiftwidth=4
set softtabstop=4
autocmd fcying_au FileType vim,json 
      \ set shiftwidth=2 
      \ | set softtabstop=2 
      \ | set tabstop=2 
      \ | set expandtab
set autoindent
set smartindent
set cindent
set indentexpr=""
set backspace=indent,eol,start 
set whichwrap+=<,>,[,],h,l
set iskeyword -=-
set iskeyword -=.
"aligin #
set cinkeys-=0#
"inoremap # X#        
"set iskeyword -=#
autocmd fcying_au FileType * setlocal formatoptions-=o formatoptions+=mM

set number
set ruler
set laststatus=2
"set noshowmatch
set nolist
set wrap
set showcmd
"set cmdheight=1
set virtualedit=onemore        "onemore all
set lazyredraw

set foldmethod=manual
set nofoldenable

" hide number
function! HideNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
nnoremap <F2> :call HideNumber()<CR>

nnoremap <F3> :set list! list?<CR>
nnoremap <F4> :set wrap! wrap?<CR>

set pastetoggle=<F5>
" disbale paste mode when leaving insert mode
autocmd fcying_au InsertLeave * set nopaste
" Automatically set paste mode in Vim when pasting in insert mode
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ''
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

" fast save
nnoremap <C-s> :<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>

" save with sudo;  use vim-eunuch instead
"nnoremap <leader>ws :w !sudo tee %<CR>

" Wrapped lines goes down/up to next row, rather than next line in file
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

xnoremap < <gv
xnoremap > >gv|
nnoremap > >>_
nnoremap < <<_

" shell
nnoremap <leader>vs :rightbelow vertical terminal<CR> 
nnoremap <leader>hs :terminal<CR> 

" Start new line
inoremap <S-Return> <C-o>o

"delete space, delete ^M
nnoremap <leader>ds :%s/\s\+$//g<CR>:noh<CR>
nnoremap <leader>dm :%s/\r$//g<CR>:noh<CR>

" virtual mode search
vnoremap <silent> * :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy/<C-R><C-R>=substitute(
      \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy?<C-R><C-R>=substitute(
      \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>

" auto pairs
"inoremap ( ()<ESC>i
"inoremap ) <c-r>=ClosePair(')')<CR>
inoremap {<CR> {}<ESC>i<CR><c-o><s-o>
inoremap } <c-r>=ClosePair('}')<CR>
"inoremap [ []<ESC>i
"inoremap ] <c-r>=ClosePair(']')<CR>
"inoremap " <c-r>=CloseSamePair('"')<CR>
"inoremap ' <c-r>=CloseSamePair('''')<CR>

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
endf


" golang
function! GetGoTools()
  if g:has_go
    silent !echo "get -u gocode godef gotags goimports"
    if g:is_win
      silent !taskkill /F /IM gocode.exe
      silent !go get -u -ldflags -H=windowsgui github.com/nsf/gocode
      silent !gocode set lib-path %GOPATH%\pkg\windows_386
    else
      silent !killall gocode
      silent !go get -u github.com/nsf/gocode
      silent !gocode set lib-path $GOPATH/pkg/linux_amd64
    endif
    silent !go get -u github.com/rogpeppe/godef
    silent !go get -u github.com/jstemmer/gotags
    silent !go get -u golang.org/x/tools/cmd/goimports
  endif
endfunction

autocmd fcying_au BufWritePost *.go call s:fcy_goimports()
command! -nargs=0 GoImports call s:fcy_goimports()
command! -nargs=0 GoRun call s:fcy_gorun()
command! -nargs=0 GoBuild call s:fcy_gobuild()
function! s:fcy_goimports()
  "let l:line = line('.')
  "let l:col = col('.')
  "silent %!goimports
  "call cursor(l:line, l:col)
  let l:cmd = 'goimports -w ' . expand('%')
  call system(l:cmd)
  e
endfunction
function! s:fcy_gorun()
  let l:cmd = 'silent !go run ' . expand('%')
  exec l:cmd
  "call vimproc#system_bg(l:cmd)
endfunction
function! s:fcy_gobuild()
  let l:cmd = 'go build -ldflags "-H windowsgui" ' . expand('%')
  call vimproc#system_bg(l:cmd)
endfunction

" set filetype
autocmd fcying_au BufNewFile,BufRead *.qml setl filetype=qml
autocmd fcying_au BufNewFile,BufRead *.conf setl filetype=conf
autocmd fcying_au BufNewFile,BufRead .vimconf setl filetype=vim

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"

if FindPlug('delimitMate') != -1
  imap <expr><CR> pumvisible() ? "\<C-y>" : "<Plug>delimitMateCR"
else
  inoremap <expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
endif

set completeopt=menu,longest       "menu longest noinsert preview

" large file
let g:LargeFile = 1024 * 1024 * 10
autocmd fcying_au BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
function! LargeFile()
  set binary
  " no syntax highlighting etc
  set eventignore+=FileType
  "syntax off
  " display message
  autocmd fcying_au VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

" }}}



" ============================================================================
" color {{{
" ============================================================================
if g:is_win
  let g:colorscheme = get(g:, 'colorscheme', 'NeoSolarized')
else
  let g:colorscheme = get(g:, 'colorscheme', 'solarized')
endif    

if &term =~# '256color' 
  " disable background color erase
  set t_ut=
endif

if g:is_nvim ==# 0
  "enable 256 colors in ConEmu on Win
  if g:is_win && !s:is_gui && !empty($CONEMUBUILD)
    set term=xterm
  endif
endif

if g:colorscheme ==# 'solarized'
  let g:solarized_termcolors=256
  set t_Co=256
  let g:background=get(g:, 'background', 'light')
  if g:is_win && !s:is_gui && !empty($CONEMUBUILD)
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
  endif
elseif g:colorscheme ==# 'molokai'
  let g:rehash256 = 1
  let g:molokai_original = 1
  let g:background=get(g:, 'background', 'dark')
elseif g:colorscheme ==# 'NeoSolarized'    
  set termguicolors
  let g:neosolarized_vertSplitBgTrans = 0
  let g:background=get(g:, 'background', 'light')
  set t_8b=[48;2;%lu;%lu;%lum    
  set t_8f=[38;2;%lu;%lu;%lum
else    
  let g:background=get(g:, 'background', 'dark')
  set t_Co=256
endif

exec 'colorscheme ' . g:colorscheme
exec 'set background=' . g:background
" }}}


if filereadable($HOME . '/.vimrc.post')
  execute 'source ' . $HOME .'/.vimrc.post'
endif

" find project file
let s:vimconf_path = findfile('.vimconf', '.;')
if s:vimconf_path !=# ''
  exec 'source ' . s:vimconf_path
endif

