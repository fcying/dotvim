"check environment {{{
if &compatible
    set nocompatible
endif    

let g:os_osx = 0
let g:os_linux = 0
let g:os_windows = 0
if has('macunix')
    let g:os_osx = 1
elseif (has('unix') && !has('macunix') && !has('win32unix'))
    let g:os_linux = 1
elseif (has('win16') || has('win32') || has('win64'))
    let g:os_windows = 1
endif

if has('gui_running')
    let s:use_gui = 1
else
    let s:use_gui = 0
endif

let g:config_dir = $HOME . '/.vim'
let g:file_plug = g:config_dir . '/plug.vim'

"}}}



" ============================================================================
" basic settings {{{
" ============================================================================
if filereadable($HOME . '/.vimrc.pre')
    execute 'source ' . $HOME .'/.vimrc.pre'
endif

let mapleader = get(g:,'mapleader',';')

"autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>ep :execute 'e ' . g:file_plug<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ez :e ~/.zshrc<CR>

if !has('nvim')
    if g:os_windows
        set renderoptions=type:directx,level:0.50,
                \gamma:1.0,contrast:0.0,geom:1,renmode:5,taamode:1
    else
        set clipboard=exclude:.*    "setup clipboard make startup slow
    endif
else
    set guicursor=
endif
 
if s:use_gui
    set guioptions -=T
    set guioptions -=m
    set mouse=a
    set guifont=Consolas:h11
    au GUIEnter * simalt ~x
else
    set mouse=nv
endif
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif
"close beep
set vb t_vb=       
set novisualbell
set noerrorbells
autocmd VimEnter * set shellredir=>
set ttyfast     " when will this cause problems?

"set langmenu=zh_CN.UTF-8
"set helplang=cn
let $LANG='en' "zh-cn gina work error
set encoding=utf-8
"set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set fileformat=dos
if g:os_windows
    set ffs=dos,unix,mac
else
    set ffs=unix,dos,mac
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
if g:os_windows
    let $PATH = g:config_dir . '\lib' . ';' . $PATH
elseif g:os_linux
    let $PATH = g:config_dir . '/lib' . ':' . $PATH
endif

set expandtab        "%retab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set cindent
set indentexpr=""
"set cinkeys-=0#
"inoremap # X#        " aligin #
set backspace=indent,eol,start 
set whichwrap+=<,>,[,],h,l
set iskeyword -=-
set iskeyword -=.
"set iskeyword -=#

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
au InsertLeave * set nopaste
" Automatically set paste mode in Vim when pasting in insert mode
function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" Wrapped lines goes down/up to next row, rather than next line in file
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

xnoremap < <gv
xnoremap > >gv|
nnoremap > >>_
nnoremap < <<_

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

nmap <c-]> :tj <c-r><c-w><CR>

" golang
autocmd! BufWritePost *.go call s:fcy_goimports()
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

au BufNewFile,BufRead *.qml set filetype=qml
au BufNewFile,BufRead *.conf set filetype=conf

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr><cr> pumvisible() ? "\<C-y>" : "\<cr>"
set completeopt=menu,longest       "menu longest noinsert preview

if filereadable(g:file_plug)
    execute 'source ' . g:file_plug
endif
filetype plugin indent on
syntax enable

" }}}



" ============================================================================
" color {{{
" ============================================================================
if g:os_windows
    let g:colorscheme = get(g:, 'colorscheme', 'NeoSolarized')
else
    let g:colorscheme = get(g:, 'colorscheme', 'solarized')
endif    

if &term =~ '256color' 
    " disable background color erase
    set t_ut=
endif

if !has('nvim')
    "enable 256 colors in ConEmu on Win
    if g:os_windows && !has('gui_running') && !empty($CONEMUBUILD)
        set term=xterm
    endif
endif

if g:colorscheme == 'solarized'
    let g:solarized_termcolors=256
    set t_Co=256
    let g:background=get(g:, 'background', 'light')
    if g:os_windows && !has('gui_running') && !empty($CONEMUBUILD)
        let &t_AB="\e[48;5;%dm"
        let &t_AF="\e[38;5;%dm"
    endif
elseif g:colorscheme == 'molokai'
    let g:rehash256 = 1
    let g:molokai_original = 1
    let g:background=get(g:, 'background', 'dark')
elseif g:colorscheme == 'NeoSolarized'    
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
let s:vimconf_path = findfile(".vimconf", ".;")
if s:vimconf_path != ""
    exec 'source ' . s:vimconf_path
endif

