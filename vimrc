" check environment {{{
if get(s:, 'loaded', 0) != 0
  finish
else
  let s:loaded = 1
endif

if &compatible
  " vint: -ProhibitSetNoCompatible
  set nocompatible
endif

let g:is_osx = has('macunix')
let g:is_linux = has('unix') && !has('macunix') && !has('win32unix')
let g:is_win = has('win32')
let g:is_nvim = has('nvim')
let g:is_vim8 = v:version >= 800 ? 1 : 0
let g:has_go = executable('go') ? 1 : 0
let g:is_gui = has('gui_running') || !empty($NVIM_GUI)
let g:is_tmux = exists('$TMUX')
let g:is_conemu = !empty($CONEMUBUILD)

if executable('pip3') ==# 0
  echohl WarningMsg
  echom 'You need install python3 && pip3!'
  echohl None
endif

let g:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:cache_dir = g:config_dir . '/.cache'
let g:etc_dir = g:config_dir . '/etc'
let g:file_plug = g:config_dir . '/plug.vim'
let g:file_vimrc = g:config_dir . '/vimrc'
let g:file_vimrc_local = $HOME .'/.vimrc.local'
let g:root_markers = ['.root', '.git', '.svn']
let g:scm_dir = ''

exec 'set rtp+=' . g:config_dir

if !isdirectory(g:cache_dir)
  call mkdir(g:cache_dir)
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
    "echom g:scm_dir
  endif
endfunction
call GetRootDir()

function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

"}}}



" ============================================================================
" basic settings {{{
" ============================================================================
let g:mapleader = get(g:,'mapleader',' ')

augroup myau
  autocmd!
augroup END

if filereadable(g:file_vimrc_local)
  execute 'source ' . g:file_vimrc_local
endif

" find project vimrc
let g:pvimrc_path = findfile('.pvimrc', g:scm_dir . ';' . g:scm_dir . '..')
if g:pvimrc_path !=# ''
  exec 'sandbox source ' . g:pvimrc_path
  "echom g:pvimrc_path
else
  let g:pvimrc_path = g:scm_dir . '/.pvimrc'
endif


" add plugin
if !exists('g:plugs_order')
  let g:plugs_order = []
endif
function! HasPlug(plugname) abort
  return index(g:plugs_order, a:plugname)
endfunction

if filereadable(g:file_plug)
  execute 'source ' . g:file_plug
endif


nnoremap <silent> <leader>evv :execute 'e '  . g:file_vimrc<CR>
nnoremap <silent> <leader>evl :execute 'e '  . g:file_vimrc_local<CR>
nnoremap <silent> <leader>evp :execute 'e '  . g:file_plug<CR>
nnoremap <silent> <leader>evz :execute 'e '  . g:etc_dir . '/zshrc'<CR>

nnoremap <silent> <leader>ep  :execute 'e '  . g:pvimrc_path<CR>
execute 'autocmd myau BufWritePost .pvimrc nested sandbox so ' . g:pvimrc_path
"autocmd! bufwritepost _vimrc source $MYVIMRC

" cursor
if g:is_nvim
  au VimEnter,VimResume * set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
  au VimLeave,VimSuspend * set guicursor=a:hor50-blinkon200
endif

" gui
set mouse=nv
if g:is_nvim
  function! s:nvim_gui_enter()
    call rpcnotify(0, "Gui", "Option", "Popupmenu", 0)
    "nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    "inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    "vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
    set mouse=a
  endfunction
  au myau UiEnter * call s:nvim_gui_enter()
  unlet $DISPLAY  "some platform have DISPLAY make clipboard.vim slow
  set clipboard+=unnamedplus
else
  set clipboard=exclude:.*    "some platform setup clipboard make startup slow
  if g:is_gui
    set guioptions -=T
    set guioptions -=m
    set mouse=a
    if g:is_win
      set guifont=Consolas:h11
    endif
    autocmd myau GUIEnter * simalt ~x
  endif
endif

" tmux
if g:is_tmux
  " tmux knows the extended mouse mode
  if g:is_nvim ==# 0
    set ttymouse=xterm2
  endif
  set ttimeoutlen=30
else
  if &ttimeoutlen > 80 || &ttimeoutlen <= 0
    set ttimeoutlen=80
  endif
endif

" disable beep
set t_vb=
set visualbell
set noerrorbells

" encoding {{{
let $LANG='en' "zh-cn gina work error
set encoding=utf-8
set fileencoding=utf-8
scriptencoding utf-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,euc-kr,latin1
if g:is_win
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif

" basic {{{
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
set tags=tags,tags;
if g:is_win
  let $PATH = g:config_dir . '\lib' . ';' . $PATH
elseif g:is_linux
  let $PATH = g:config_dir . '/lib' . ':' . $PATH
endif
set history=2000
set scrolloff=3
set hidden
set noautochdir
set updatetime=300

" autoread {{{
set autoread
augroup checktime
  au!
  autocmd FocusGained,BufEnter        * silent! checktime
  autocmd CursorHold                  * silent! checktime
  autocmd CursorHoldI                 * silent! checktime
augroup END

" backup {{{
set nobackup
set nowritebackup
set undofile
execute 'set undodir=' . g:cache_dir . '/undodir'
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
set listchars=tab:▸\ ,trail:.,nbsp:+,extends:❯,precedes:❮
set showcmd
set wildmenu
set wildmode=longest:full,full
set splitright
set splitbelow
if $TERM !=# "ansi"
  set lazyredraw  "vim-plug scripts update error: Vim: Error reading input, exiting
endif
if has('patch-8.1.1564')
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=auto
endif

" search {{{
set magic
set incsearch
set hlsearch
set wrapscan    "search loop
set ignorecase
set smartcase
if g:is_nvim
  set inccommand=nosplit
endif

" tab shift {{{
set expandtab        "%retab
set tabstop=4
set shiftwidth=4
set softtabstop=4
autocmd myau FileType go setlocal noexpandtab
autocmd myau FileType vim,json,jsonc,yaml,toml,dosbatch
      \ setlocal shiftwidth=2
      \ softtabstop=2
      \ tabstop=2
      \ expandtab

" quickfix {{{
"if g:is_vim8
"  set cscopequickfix=s+,c+,d+,i+,t+,e+,a+
"else
"  set cscopequickfix=s+,c+,d+,i+,t+,e+
"endif
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

" dictionary
execute 'set dictionary+=' . g:config_dir . '/dict/dictionary'
function! s:add_dict()
  let l:dict = g:config_dir . '/dict/' . &filetype . '.dict'
  if filereadable(expand(l:dict))
    execute 'setlocal dictionary+=' . l:dict
  endif
endfunction
autocmd myau FileType * :call s:add_dict()

" session
set sessionoptions-=help

" foldmethod
set foldmethod=manual
set nofoldenable

" diff opt
if has('patch-8.1.0360')
  set diffopt+=internal,algorithm:patience
endif

" ignore {{{
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class
set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android

" jump to the last position {{{
augroup vimStartup
  au!
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


" keymap {{{
nnoremap <F2> :set number! number?<CR>
nnoremap <F3> :set list! list?<CR>
nnoremap <F4> :set wrap! wrap?<CR>

set pastetoggle=<F5>
"set pastetoggle=<leader>z
" disbale paste mode when leaving insert mode
autocmd myau InsertLeave * set nopaste
" Automatically set paste mode in Vim when pasting in insert mode
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ''
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

" fast save ctrl-s {{{
nnoremap <C-s> :update<CR>
vnoremap <C-s> :<C-u>update<CR>
cnoremap <C-s> <C-u>update<CR>
inoremap <C-s> <C-o>:update<CR>

" save with sudo;  use vim-eunuch instead
"nnoremap <leader>ws :w !sudo tee %<CR>

" Wrapped lines goes down/up to next row, rather than next line in file
"nnoremap k gk
"nnoremap gk k
"nnoremap j gj
"nnoremap gj j

xnoremap < <gv
xnoremap > >gv|
nnoremap > >>_
nnoremap < <<_

" q --> Q
nnoremap Q q
nnoremap q <nop>

" insert mode emacs
inoremap <c-a> <home>
inoremap <c-e> <end>

" cmd history search
cnoremap <expr> <c-n> pumvisible() ? "<c-n>" : "<down>"
cnoremap <expr> <c-p> pumvisible() ? "<c-p>" : "<up>"

" tab
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

" fast move
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <c-d>
cnoremap <c-b> <left>
cnoremap <c-d> <del>
cnoremap <c-_> <c-k>

" terminal
tnoremap <ESC> <c-\><c-n>
if g:is_nvim
  autocmd myau TermOpen * startinsert
  tnoremap <c-o>p <c-\><c-n>pi
else
  tnoremap <c-o>p <C-W>"+
endif

" Start new line
inoremap <S-Return> <C-o>o

" delete space
nnoremap <leader>ds :%s/\s\+$//g<CR>:noh<CR>
" delete ^M
nnoremap <leader>dm :%s/\r$//g<CR>:noh<CR>
" delete ansi escape codes
nnoremap <leader>da :%s/\%x1b\[[0-9;]*m//g<CR>:noh<CR>

" set working directory to the current file
nnoremap <silent> <leader>cdt :tcd %:p:h<CR>:pwd<CR>
nnoremap <silent> <leader>cda :cd %:p:h<CR>:pwd<CR>

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
inoremap {<CR> {<CR>}<c-o><s-o>
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
function! s:getgotools()
  if g:has_go
    silent !GO111MODULE=on go get -v golang.org/x/tools/cmd/goimports
    silent !GO111MODULE=on go get -v golang.org/x/tools/gopls@latest
  endif
endfunction
function! s:goformat()
  let l:curw = winsaveview()
  silent execute '%!gofmt %'
  call winrestview(l:curw)
endfunction
function! s:goimports()
  let l:curw = winsaveview()
  silent execute '%!goimports %'
  call winrestview(l:curw)
endfunction
function! s:gosave()
  w
  GoFmt
  GoImports
endfunction

augroup go_lang
  autocmd!
  autocmd! * <buffer>
  command! -nargs=0 GoImports call s:goimports()
  command! -nargs=0 GoFmt call s:goformat()
  command! -nargs=0 GoSave call s:gosave()
  command! -nargs=0 GoGetTools call s:getgotools()
  "autocmd FileType go autocmd BufWritePre <buffer> GoSave
augroup END

" set filetype {{{
autocmd myau BufNewFile,BufRead *.conf setl filetype=conf
autocmd myau BufNewFile,BufRead *.json setl filetype=jsonc
autocmd myau BufNewFile,BufRead .tasks setl filetype=conf

" completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
" close menu and start a new line
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>": "\<cr>"
set completeopt=noinsert,menuone,noselect
set shortmess+=c
if has('patch-8.1.1902')
  set completeopt+=popup
  set completepopup=border:off
endif

" large file
let g:LargeFile = 1024 * 1024 * 10
autocmd myau BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
function! LargeFile()
  set binary
  " no syntax highlighting etc
  "set eventignore+=FileType
  " display message
  autocmd myau VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

" paste without overwrite register
xnoremap p "_dP


" }}}



" ============================================================================
" color {{{
" ============================================================================
" solarized8 gruvbox molokai
let g:colorscheme = get(g:, 'colorscheme', 'solarized8')

if !exists('g:lightline')
  let g:lightline = {}
endif

let g:background=get(g:, 'background', 'light')
if g:colorscheme ==# 'molokai'
  let g:background='dark'
  let g:lightline.colorscheme=get(g:, 'lightline_colorscheme', 'wombat')
else
  let g:lightline.colorscheme=get(g:, 'lightline_colorscheme', 'solarized')
endif

if strlen(globpath(&rtp, 'colors/' . g:colorscheme . '.vim')) ==# 0
  "echom "use default colorscheme"
  let g:colorscheme = 'default'
  let g:background=get(g:, 'background', 'light')
  let g:lightline.colorscheme=get(g:, 'lightline.colorscheme', 'solarized')
endif

if has('termguicolors')
  " :h xterm-true-color
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
else
  set t_Co=256
endif

if $TERM =~# '256color' && g:is_tmux
	" disable Background Color Erase (BCE) so that color schemes
	" render properly when inside 256-color tmux and GNU screen.
	" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
	set t_ut=
elseif $TERM ==# 'linux'
  let g:colorscheme = 'desert'
  let g:background='dark'
  set t_Co=256
endif


if g:is_nvim ==# 0
  "enable 256 colors in ConEmu on Win
  if g:is_win && !g:is_gui && g:is_conemu
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

if exists('*LoadAfterProject')
  call LoadAfterProject()
endif

filetype plugin indent on
syntax enable

if (HasPlug('LeaderF') != -1)
  autocmd myau Syntax * hi Lf_hl_cursorline guifg=fg
endif
