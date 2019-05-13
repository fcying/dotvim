" check environment {{{
if &compatible
  " vint: -ProhibitSetNoCompatible
  set nocompatible
endif

let g:is_osx = has('macunix')
let g:is_lin = has('unix') && !has('macunix') && !has('win32unix')
let g:is_win = has('win32')
let g:is_nvim = has('nvim')
let g:is_vim8 = v:version >= 800 ? 1 : 0
let g:has_go = executable('go') ? 1 : 0
let s:is_gui = has('gui_running')
let g:is_tmux = &term =~# '^screen' ? 1 : 0

let g:config_dir = expand('<sfile>:p:h')
let g:file_plug = g:config_dir . '/plug.vim'
let g:file_vimrc = g:config_dir . '/vimrc'
let g:file_vimrc_local = $HOME .'/.vimrc.local'

"}}}



" ============================================================================
" basic settings {{{
" ============================================================================
if filereadable(g:file_vimrc_local)
  execute 'source ' . g:file_vimrc_local
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
nnoremap <leader>ev :execute 'e ' . g:file_vimrc<CR>
nnoremap <leader>el :execute 'e ' . g:file_vimrc_local<CR>
nnoremap <leader>ep :execute 'e ' . g:file_plug<CR>
nnoremap <leader>sv :execute 'source ' . g:file_vimrc<CR>
nnoremap <leader>ez :e ~/.zshrc<CR>
nnoremap <leader>ezl :e ~/.zshrc.local<CR>

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
if g:is_tmux
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
set scrolloff=3
set hidden
set noswapfile
set nobackup
set nowritebackup
set undofile
execute 'set undodir=' . g:config_dir . '/.cache/undodir'
if !isdirectory(g:config_dir . '/.cache/undodir')
  call mkdir(g:config_dir . '/.cache/undodir', 'p')
endif
set splitright
set splitbelow
set noautochdir
set regexpengine=1        " use old re, for speed syntax
set updatetime=300
set autoread
augroup checktime
  au!
  if !s:is_gui
    "silent! necessary otherwise throws errors when using command line window.
    autocmd FocusGained,BufEnter        * silent! checktime
    autocmd CursorHold                  * silent! checktime
    autocmd CursorHoldI                 * silent! checktime
  endif
augroup END

set wildmenu
set wildmode=longest:full,full
set wildignore=*.bak,*.o,*.e,*.swp,.git,.svn,*.pyc,*.class

"set cursorcolumn
set cursorline
set signcolumn=number

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
autocmd fcying_au FileType go setlocal noexpandtab
autocmd fcying_au FileType vim,json,yaml,toml,dosbatch
      \ setlocal shiftwidth=2
      \ softtabstop=2
      \ tabstop=2
      \ expandtab

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

execute 'set dictionary+=' . g:config_dir . '/etc/dictionary'

set foldmethod=manual
set nofoldenable

if has('patch-8.1.0360')
  set diffopt+=internal,algorithm:patience
endif


" jump to the last position
augroup vimStartup
  au!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif

augroup END

" get file realpath
function! GetCurFileRealPath()
  echo expand('%:p')
endfunc
nnoremap <leader>F :call GetCurFileRealPath()<CR>

" get visual selection
func! GetVisualSelection() abort
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    "echo join(lines, "\n")
    return join(lines, "\n")
endf


nnoremap <F2> :set number! number?<CR>
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
endfunction

" Without any arguments the current buffer is kept.  With an argument the buffer name/number supplied is kept.
" https://github.com/vim-scripts/BufOnly.vim
command! -nargs=? -complete=buffer -bang Bufonly
    \ :call BufOnly('<args>', '<bang>')

function! BufOnly(buffer, bang)
	if a:buffer ==# ''
		" No buffer provided, use the current buffer.
		let buffer = bufnr('%')
	elseif (a:buffer + 0) > 0
		" A buffer number was provided.
		let buffer = bufnr(a:buffer + 0)
	else
		" A buffer name was provided.
		let buffer = bufnr(a:buffer)
	endif

	if buffer == -1
		echohl ErrorMsg
		echomsg 'No matching buffer for' a:buffer
		echohl None
		return
	endif

	let last_buffer = bufnr('$')

	let delete_count = 0
	let n = 1
	while n <= last_buffer
		if n != buffer && buflisted(n)
			if a:bang ==# '' && getbufvar(n, '&modified')
				echohl ErrorMsg
				echomsg 'No write since last change for buffer'
							\ n '(add ! to override)'
				echohl None
			else
				silent exe 'bw' . a:bang . ' ' . n
				if ! buflisted(n)
					let delete_count = delete_count+1
				endif
			endif
		endif
		let n = n+1
	endwhile

	if delete_count == 1
		echomsg delete_count 'buffer deleted'
	elseif delete_count > 1
		echomsg delete_count 'buffers deleted'
	endif
endfunction

" golang
function! s:gogettools()
  if g:has_go
    silent !go get -u -v github.com/sourcegraph/go-langserver
    silent !go get -u -v golang.org/x/tools/cmd/goimports
  endif
endfunction
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

augroup go_lang
  autocmd!
  "autocmd BufWritePost *.go call s:fcy_goimports()
  command! -nargs=0 GoImports call s:fcy_goimports()
  command! -nargs=0 GoRun call s:fcy_gorun()
  command! -nargs=0 GoBuild call s:fcy_gobuild()
  command! -nargs=0 GoGetTools call s:gogettools()
augroup END

" set filetype
autocmd fcying_au BufNewFile,BufRead *.conf setl filetype=conf
autocmd fcying_au BufNewFile,BufRead .vimconf setl filetype=vim

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"

set completeopt=noinsert,menuone,noselect

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
  let g:colorscheme = get(g:, 'colorscheme', 'solarized8')
  set termguicolors
else
  let g:colorscheme = get(g:, 'colorscheme', 'solarized')
  let g:solarized_termcolors=256
  set t_Co=256
endif
let g:background=get(g:, 'background', 'light')

if &term =~# '256color'
  " disable background color erase
  set t_ut=
endif

if g:is_tmux
  set t_8f=[38;2;%lu;%lu;%lum
  set t_8b=[48;2;%lu;%lu;%lum
endif

if g:is_nvim ==# 0
  "enable 256 colors in ConEmu on Win
  if g:is_win && !s:is_gui && !empty($CONEMUBUILD)
    set term=xterm
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
  endif
endif

exec 'colorscheme ' . g:colorscheme
exec 'set background=' . g:background
" }}}


if exists('*LoadAfter')
  call LoadAfter()
endif

" find project file
let s:vimconf_path = findfile('.vimconf', '.;')
if s:vimconf_path !=# ''
  exec 'source ' . s:vimconf_path
endif

