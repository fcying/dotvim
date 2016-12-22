set nocompatible

"check environment {{{
let s:os_osx = 0
let s:os_linux = 0
let s:os_windows = 0
if has('macunix')
    let s:os_osx = 1
elseif (has('unix') && !has('macunix') && !has('win32unix'))
    let s:os_linux = 1
elseif (has('win16') || has('win32') || has('win64'))
    let s:os_windows = 1
endif

if has('gui_running')
    let s:use_gui = 1
else
    let s:use_gui = 0
endif
"}}}

if s:os_windows
    let g:config_dir=$VIM
elseif s:os_linux
    let g:config_dir = '~/.vim'
endif

" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

let mapleader   = ","


"autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ee :e $MYVIMRC<CR>

"behave mswin        "set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

if s:os_windows
    set renderoptions=type:directx,level:0.50,
                \gamma:1.0,contrast:0.0,geom:1,renmode:5,taamode:1
endif

if s:use_gui
    set guioptions -=T
    set guioptions -=m
    set mouse=a
    set guifont=Consolas:h11
    au GUIEnter * simalt ~x
else
    set mouse=n
endif
set wildmenu
set wildmode=longest:full,full
set wildignore=*.bak,*.o,*.e,*~,*.swp
set ttyfast     " when will this cause problems?
autocmd GUIEnter * set vb t_vb=       "close beep
set noerrorbells
autocmd VimEnter * set shellredir=>

" Easier moving in tabs and windows
"map <C-H> <C-W>h
"map <C-J> <C-W>j
"map <C-K> <C-W>k
"map <C-L> <C-W>l

" Wrapped lines goes down/up to next row, rather than next line in file
map j gj
map k gk

" Visual shifting (does not exit Visual mode)
vmap < <gv
vmap > >gv

"delete space, delete ^M
nnoremap <leader>ds :%s/\s\+$//<CR>
nnoremap <leader>dm :%s/\r//g<CR>

"set langmenu=zh_CN.UTF-8
"set helplang=cn
set encoding=utf-8
"set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set fileformat=dos
if s:os_windows
    set ffs=dos,unix,mac
else
    set ffs=unix,dos,mac
endif

set updatetime=1000
set scrolloff=3
set hidden
set noswapfile
set nobackup
set nowritebackup
set splitright
set splitbelow

set incsearch
set hlsearch
set wrapscan    "search loop
set ignorecase
set smartcase
set noautochdir
set path+=../inc,../src,
if s:os_windows
    let $PATH = g:config_dir . '\lib' . ';' . $PATH
elseif s:os_linux
    let $PATH = g:config_dir . '/lib' . ':' . $PATH
endif

set expandtab        "%retab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set indentexpr=""
set cinkeys-=0#
inoremap # X#

set number
set ruler
set noshowmatch
set nolist
set wrap
set laststatus=2
set statusline=%F%m%r%w%=[%{&ff},%{&fenc}]\ [%Y]\ [A=\%03.3b,H=\%02.2B]\ [%04l,%04v,%p%%]
set showcmd
"set cmdheight=1
set backspace=indent,eol,start whichwrap+=<,>,[,]
set iskeyword -=-
set iskeyword -=.
set iskeyword -=#
set virtualedit=onemore        "onemore all
"set paste

set foldmethod=manual
set nofoldenable

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
inoremap ( ()<ESC>i
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap {<CR> {}<ESC>i<CR><c-o><s-o>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=ClosePair(']')<CR>
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

if s:os_windows
    set tags=tags
else
    set tags=tags
endif
nmap <c-]> :tj <c-r><c-w><CR>
nmap <F3> <c-]>
nmap <F4> <C-o>
nmap <Leader>tn :tnext<CR>
nmap <Leader>tp :tprevious<CR>

" gen tag
nmap <silent> <Leader>cr :FcyGentags<CR>
nmap <silent> <F5> :FcyGentags<CR>
command! -nargs=0 FcyGentags call s:fcy_gen_tags()
function! s:fcy_gen_tags()
    "let l:cmd = 'ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
    let l:cmd = 'ctags -R --fields=+iaS --extra=+q'
    "let l:cmd = 'ctags -R'
    call vimproc#system_bg(l:cmd)
    call vimproc#system_bg('gtags')
    echon "gen tags done"
endfunction

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

" autocomplete
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
inoremap <expr> <c-j>     pumvisible() ? "\<c-n>" : "\<c-j>"
inoremap <expr> <c-k>       pumvisible() ? "\<c-p>" : "\<c-k>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType autohotkey setl omnifunc=ahkcomplete#Complete

au BufNewFile,BufRead *.qml set filetype=qml

let s:vimconf_path = findfile(".vimconf", ".;")
if s:vimconf_path != ""
    exec 'source ' . s:vimconf_path
endif

filetype plugin indent on
syntax on

" }}}
" ============================================================================
" Plugins {{{
" ============================================================================
let s:useYCM    = 0

let s:plugin_groups = []
call add(s:plugin_groups, 'fencview')
call add(s:plugin_groups, 'tellenc')
call add(s:plugin_groups, 'vim-bbye')
"call add(s:plugin_groups, 'ultisnips')
"call add(s:plugin_groups, 'ctrlp')
call add(s:plugin_groups, 'ctrlsf')
call add(s:plugin_groups, 'vim-multiple-cursors')
call add(s:plugin_groups, 'unite')
call add(s:plugin_groups, 'vimproc')
"call add(s:plugin_groups, 'vimfiler')
call add(s:plugin_groups, 'vimshell')
"call add(s:plugin_groups, 'vim-signature')
call add(s:plugin_groups, 'tagbar')
call add(s:plugin_groups, 'vim-session')
call add(s:plugin_groups, 'vim-cpp-enhanced-highlight')
"call add(s:plugin_groups, 'fastfold')
if s:useYCM
   call add(s:plugin_groups, 'YouCompleteMe')
else
    if has('nvim')
       call add(s:plugin_groups, 'deoplete')
    else
       if has('lua')
           call add(s:plugin_groups, 'neocomplete')
       endif
    endif
    "call add(s:plugin_groups, 'vim-clang')
    "call add(s:plugin_groups, 'clang_complete')
endif
if (executable('go'))
    "call add(s:plugin_groups, 'vim-go')
    call add(s:plugin_groups, 'gocode')
endif
call add(s:plugin_groups, 'vim-fswitch')
call add(s:plugin_groups, 'nerdtree')
call add(s:plugin_groups, 'nerdcommenter')
call add(s:plugin_groups, 'vim-easymotion')
"call add(s:plugin_groups, 'ack.vim')
"call add(s:plugin_groups, 'ag.vim')
"call add(s:plugin_groups, 'vim-easygrep')
call add(s:plugin_groups, 'vim-indent-guides')
call add(s:plugin_groups, 'autohotkey-ahk')
call add(s:plugin_groups, 'vim-AHKcomplete')
call add(s:plugin_groups, 'vim-markdown')
"call add(s:plugin_groups, 'vim-instant-markdown')
if (executable('ctags') && executable('gtags'))
    "call add(s:plugin_groups, 'gen_tags.vim')
endif

"color
call add(s:plugin_groups, 'solarized')
"call add(s:plugin_groups, 'molokai')
" }}}

" ============================================================================
" Plugin SETTINGS {{{
" ============================================================================
silent! if plug#begin(g:config_dir . '/plugged')
if count(s:plugin_groups, 'fencview')
    Plug 'mbbill/fencview'
endif
if count(s:plugin_groups, 'tellenc')
    Plug  'adah1972/tellenc'
endif
if count(s:plugin_groups, 'nerdtree')
    Plug  'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
endif
if count(s:plugin_groups, 'tagbar')
    Plug  'https://github.com/fcymk2/tagbar', { 'on': 'TagbarToggle' }
endif
if count(s:plugin_groups, 'vim-session')
    Plug  'https://github.com/xolox/vim-misc'
    Plug  'https://github.com/xolox/vim-session'
endif
if count(s:plugin_groups, 'vimproc')
    function! BuildVimproc(info)
        " info is a dictionary with 3 fields
        " - name:   name of the plugin
        " - status: 'installed', 'updated', or 'unchanged'
        " - force:  set on PlugInstall! or PlugUpdate!
        if a:info.status != 'unchanged' || a:info.force
            if s:os_windows
                silent !Tools\update-dll-mingw.bat
            else
                silent !make
            endif
        endif
    endfunction
    Plug 'Shougo/vimproc.vim', {'do' : function('BuildVimproc')}
endif
if count(s:plugin_groups, 'vimshell')
    Plug 'Shougo/vimshell.vim', {'on': 'VimShell'}
endif
if count(s:plugin_groups, 'vimfiler')
    Plug 'Shougo/vimfiler.vim'
endif
if count(s:plugin_groups, 'vim-bbye')
    Plug  'moll/vim-bbye', {'on': 'Bdelete'}
endif
if count(s:plugin_groups, 'ultisnips')
    Plug  'SirVer/ultisnips'
endif
if count(s:plugin_groups, 'ctrlp')
    Plug  'ctrlpvim/ctrlp.vim', {'on': 'CtrlP'}
endif
if count(s:plugin_groups, 'ctrlsf')
    Plug 'dyng/ctrlsf.vim'
endif
if count(s:plugin_groups, 'vim-multiple-cursors')
    Plug  'terryma/vim-multiple-cursors'
endif
if count(s:plugin_groups, 'unite')
    Plug 'Shougo/unite.vim'
    Plug 'Shougo/unite-outline'
    Plug 'Shougo/neomru.vim'
    Plug 'Shougo/neoyank.vim'
endif
if count(s:plugin_groups, 'vim-signature')
    Plug  'kshenoy/vim-signature'
endif
if count(s:plugin_groups, 'vim-cpp-enhanced-highlight')
    Plug 'octol/vim-cpp-enhanced-highlight'
endif
if count(s:plugin_groups, 'fastfold')
    Plug 'Konfekt/FastFold'
endif
if count(s:plugin_groups, 'neocomplete')
    Plug  'Shougo/neocomplete.vim'
endif
if count(s:plugin_groups, 'vim-go')
    Plug  'fatih/vim-go'
endif
if count(s:plugin_groups, 'gocode')
    function! GetGoCode(info)
        if a:info.status != 'unchanged' || a:info.force
            silent !go get -u golang.org/x/tools/cmd/goimports
            silent !go get -u github.com/rogpeppe/godef
            silent !go get -u github.com/jstemmer/gotags
            if s:os_windows
                silent !go get -u github.com/mattn/files    "for unite
                silent !taskkill /F /IM gocode.exe
                silent !go get -u -ldflags -H=windowsgui github.com/nsf/gocode
                "silent !go get -u github.com/nsf/gocode
                let l:cmd = 'cp -R ' . g:config_dir . '\plugged\gocode\vim\ftplugin '
                            \ . $HOME . '\vimfiles'
                call system(l:cmd)
                let l:cmd = 'cp -R ' . g:config_dir . '\plugged\gocode\vim\autoload ' . $HOME
                            \ . '\vimfiles'
                call system(l:cmd)
                gocode set lib-path %GOPATH%\pkg\windows_386
            else
                silent !killall gocode
                silent !go get -u github.com/nsf/gocode
                let l:cmd = 'sh ' . g:config_dir . '/plugged/gocode/vim/update.sh'
                call system(l:cmd)
                gocode set lib-path $GOPATH/pkg/linux_386
            endif
      endif
    endfunction
    Plug 'nsf/gocode', {'do': function('GetGoCode')}
    Plug 'dgryski/vim-godef'
endif
if count(s:plugin_groups, 'vim-clang')
    Plug 'https://github.com/fcymk2/vim-clang'
endif
if count(s:plugin_groups, 'clang_complete')
    Plug  'Rip-Rip/clang_complete'
endif
if count(s:plugin_groups, 'deoplete')
    Plug 'Shougo/deoplete.nvim'
endif
if count(s:plugin_groups, 'YouCompleteMe')
    Plug 'Valloric/YouCompleteMe'
endif
if count(s:plugin_groups, 'vim-fswitch')
    Plug 'derekwyatt/vim-fswitch'
endif
if count(s:plugin_groups, 'nerdcommenter')
    Plug  'scrooloose/nerdcommenter', { 'on': '<Plug>NERDCommenterToggle' }
endif
if count(s:plugin_groups, 'vim-indent-guides')
    Plug  'nathanaelkane/vim-indent-guides', { 'on': '<Plug>IndentGuidesToggle' }
endif
if count(s:plugin_groups, 'vim-easymotion')
    Plug  'Lokaltog/vim-easymotion'
endif
if count(s:plugin_groups, 'gen_tags.vim')
    Plug  'jsfaint/gen_tags.vim'
endif
if count(s:plugin_groups, 'ack.vim')
    Plug  'mileszs/ack.vim', { 'on': 'Ack' }
endif
if count(s:plugin_groups, 'ag.vim')
    Plug  'rking/ag.vim', { 'on': 'Ag' }
endif
if count(s:plugin_groups, 'vim-easygrep')
    Plug  'dkprice/vim-easygrep'
endif
if count(s:plugin_groups, 'autohotkey-ahk')
    Plug  'autohotkey-ahk', { 'for': 'autohotkey' }
endif
if count(s:plugin_groups, 'vim-AHKcomplete')
    Plug  'vim-AHKcomplete', { 'for': 'autohotkey' }
endif
if count(s:plugin_groups, 'vim-instant-markdown')
    Plug  'suan/vim-instant-markdown', { 'for': 'markdown' }
endif
if count(s:plugin_groups, 'vim-markdown')
    Plug 'godlygeek/tabular', { 'for': 'markdown' }
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
endif
"color
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'
call plug#end()
endif

" color
if count(s:plugin_groups, 'solarized')
    let g:solarized_termcolors=256
    set background=light
    colorscheme solarized
elseif count(s:plugin_groups, 'molokai')
    let g:rehash256 = 1
    let g:molokai_original = 1
    colorscheme molokai
endif
"enable 256 colors in ConEmu on Win
if s:os_windows && s:use_gui==0 && !empty($CONEMUBUILD)
    set term=xterm
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
endif
set t_Co=256

if count(s:plugin_groups, 'fencview')
    let g:fencview_autodetect = 1
    let g:fencview_checklines = 10
endif
if count(s:plugin_groups, 'tagbar')
    let tagbar_left=1
    nnoremap <silent><Leader>tt :TagbarToggle<CR>
    nnoremap <silent><F11> :TagbarToggle<CR>
    let tagbar_width=32
    let g:tagbar_compact=1
    "autocmd FileType c,cpp,h nested :TagbarOpen
    let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }
endif
if count(s:plugin_groups, 'vim-session')
    let g:session_autosave = 'no'
    let g:session_autoload = 'no'
endif
if count(s:plugin_groups, 'unite')
    "let g:unite_data_directory=g:config_dir . '/.cache/unite'
    let g:unite_enable_start_insert=0
    let g:unite_source_history_yank_enable = 1
    let g:unite_force_overwrite_statusline=1

    call unite#filters#matcher_default#use(['matcher_fuzzy'])

    if s:os_windows
        if executable('files')
            "go get github.com/mattn/files
            let g:unite_source_rec_async_command = [
            \'files', '-a', '-i',
            \'(^(lib|Lib|out|Out|obj|Obj))
            \|(deploy)
            \|(^(tags|GTAGS|GRTAGS|GPATH)$)
            \|(^(\.git|\.hg|\.svn|_darcs|\.bzr)$)
            \',]
        endif
    endif

    if executable('ag')
        if s:os_linux
            let g:unite_source_rec_async_command = [
            \ 'ag', '--follow', '--nocolor', '--nogroup', '--hidden',
            \ '--ignore','lib', '--ignore','obj', '--ignore','out',
            \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
            \ '--ignore','deploy',
            \ '-g', '']
        endif

        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts =
        \'--vimgrep --hidden --nocolor --nogroup
        \ --ignore ''.svn'' --ignore ''.git''
        \ --ignore ''lib'' --ignore ''obj'' --ignore ''out''
        \ --ignore ''tags'' --ignore ''GTAGS'' --ignore ''GRTAGS'' --ignore ''GPATH''
        \ --ignore ''deploy''
		\'
    endif

	nnoremap [unite] <Nop>
	nmap f [unite]
	nmap <c-p> [unite]
	"nnoremap <silent> [unite]s :<C-u>Unite source<CR>
    nnoremap <silent> [unite]f :<C-u>Unite -silent -start-insert file_rec/async<CR>
	nnoremap <silent> [unite]b :<C-u>Unite -start-insert buffer bookmark<CR>
	nnoremap <silent> [unite]g :<C-u>Unite grep:.<CR>
	nnoremap <silent> [unite]l :<C-u>Unite -start-insert line<CR>
	nnoremap <silent> [unite]o :<C-u>Unite -start-insert outline<CR>
	nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
	nnoremap <silent> [unite]h :<C-u>Unite file_mru<CR>
	nnoremap <silent> [unite]p :<C-u>Unite jump_point file_point<CR>
	nnoremap <silent> [unite]r <Plug>(unite_redraw)

    autocmd FileType unite call s:unite_settings()
    function! s:unite_settings()
        nmap <buffer> Q <plug>(unite_exit)
        nmap <buffer> <esc> <plug>(unite_exit)
        imap <buffer> <esc> <plug>(unite_exit)
        imap <buffer> <C-j> <Plug>(unite_select_next_line)
        imap <buffer> <C-k> <Plug>(unite_select_previous_line)
        nmap <buffer> <C-p> <plug>(unite_exit)
        imap <buffer> <C-p> <plug>(unite_exit)
    endfunction
endif
if count(s:plugin_groups, 'vimshell')
    nnoremap <leader>vs :silent VimShell<CR>
    let g:vimshell_prompt_expr =
        \ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
    let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
    let g:vimshell_no_default_keymappings=0
endif
if count(s:plugin_groups, 'vimfiler')
    nnoremap <leader>ve :silent VimFilerExplorer<CR>
    let g:vimfiler_ignore_pattern = ['^\.git$', '^\.svn$']
endif

if count(s:plugin_groups, 'ctrlp')
    nnoremap <c-p> :CtrlP<CR>
    let g:ctrlp_show_hidden = 0
    let g:ctrlp_working_path_mode = 'a'   "ra c
    let g:ctrlp_clear_cache_on_exit = 1
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\v[\/]((\.(git|hg|svn))|(obj|backup))$',
                \ 'file': '\v\.(exe|so|dll)$',
                \ 'link': 'some_bad_symbolic_links',
                \ }
endif
if count(s:plugin_groups, 'gocode')
    "start gocode first
    function! s:fcy_CallGocode()
        if !exists('g:startGocode')
            call vimproc#system_bg('gocode')
            let g:startGocode = 1
        endif
    endfunction
    autocmd! VimEnter *.go call s:fcy_CallGocode()

    "let g:gocomplete#system_function = 'vimproc#system'
    let g:godef_split=0
    let g:godef_same_file_in_same_window=1
endif
if count(s:plugin_groups, 'vim-go')
    let g:go_bin_path = expand("$HOME/.gotools")
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_fmt_command = "goimports"
    "let g:go_fmt_fail_silently = 1

    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>t <Plug>(go-test)
    au FileType go nmap <leader>c <Plug>(go-coverage)

    au FileType go nmap <Leader>ds <Plug>(go-def-split)
    au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
    au FileType go nmap <Leader>dt <Plug>(go-def-tab)

    au FileType go nmap <Leader>gd <Plug>(go-doc)
    au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <Leader>e <Plug>(go-rename)
endif
if count(s:plugin_groups, 'neocomplete')
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#skip_auto_completion_time = ""

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

    let g:neocomplete#enable_auto_select = 0

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    set completeopt=menu,longest       "menu longest noinsert preview
endif
if count(s:plugin_groups, 'vim-multiple-cursors')
    "let g:multi_cursor_next_key='<S-n>'
    "let g:multi_cursor_prev_key='<S-p>'
    "let g:multi_cursor_skip_key='<S-x>'
    let g:multi_cursor_quit_key='<Esc>'
    " Called once right before you start selecting multiple cursors
    function! Multiple_cursors_before()
        if exists(':NeoCompleteLock')==2
            exe 'NeoCompleteLock'
        endif
    endfunction

    " Called once only when the multiple selection is canceled (default <Esc>)
    function! Multiple_cursors_after()
        if exists(':NeoCompleteUnlock')==2
            exe 'NeoCompleteUnlock'
        endif
    endfunction
endif
if count(s:plugin_groups, 'vim-clang')
    if s:os_windows
        let g:clang_exec = 'C:/LLVM/bin/clang.exe'
        let g:clang_format_exec = 'C:/LLVM/bin/clang-format.exe'
    endif
    let g:clang_auto = 0
    set completeopt=menu,noinsert       "menu,longest
    "let g:clang_c_completeopt = 'menuone,noinsert'   "'menuone,preview'
    "let g:clang_cpp_completeopt = 'menuone,preview'
    "let g:clang_auto_select=1
    let g:clang_diagsopt = ''   " <- disable diagnostics
    let g:clang_format_style = 'webkit'
    " use neocomplete
    " input patterns
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:clang_c_options = '-std=gnu11'
    let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'

    " for c and c++
    let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
endif
if count(s:plugin_groups, 'deoplete')
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#enable_refresh_always = 1
    let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
    let g:deoplete#omni#input_patterns.java = [
                \'[^. \t0-9]\.\w*',
                \'[^. \t0-9]\->\w*',
                \'[^. \t0-9]\::\w*',
                \]
    let g:deoplete#omni#input_patterns.jsp = ['[^. \t0-9]\.\w*']
    let g:deoplete#ignore_sources = {}
    let g:deoplete#ignore_sources._ = ['javacomplete2']
    call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
    inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
endif
if count(s:plugin_groups, 'vim-bbye')
    :nnoremap <Leader>q :Bdelete<CR>
endif
if count(s:plugin_groups, 'ctrlsf')
    "let g:ctrlsf_debug_mode = 1
    "redir! > ctrlsf.log
    let g:ctrlsf_ackprg = 'ag'
    let g:ctrlsf_regex_pattern = 1
    let g:ctrlsf_case_sensitive = 'smart'
    let g:ctrlsf_ignore_dir = ['tags', 'GTAGS', 'GPATH', 'GRTAGS', 'obj', 'out', 'lib*']

    nnoremap [CtrlSF] <Nop>
    nmap <leader>s [CtrlSF]
    vmap <leader>s [CtrlSF]
    nmap [CtrlSF]f :CtrlSF<CR>
    nmap [CtrlSF]i <Plug>CtrlSFPrompt
    vmap [CtrlSF]f <Plug>CtrlSFVwordExec
    vmap [CtrlSF]F <Plug>CtrlSFVwordPath
    nmap [CtrlSF]c <Plug>CtrlSFCwordPath
    nmap [CtrlSF]p <Plug>CtrlSFPwordPath
    nmap [CtrlSF]l <Plug>CtrlSFQuickfixPrompt
    vmap [CtrlSF]l <Plug>CtrlSFQuickfixVwordPath
    vmap [CtrlSF]L <Plug>CtrlSFQuickfixVwordExec
    nnoremap [CtrlSF]o :CtrlSFOpen<CR>
    nnoremap [CtrlSF]t :CtrlSFToggle<CR>
    inoremap [CtrlSF]t <Esc>:CtrlSFToggle<CR>

    let g:ctrlsf_mapping = {
        \ "next"    : "<c-w>",
        \ "prev"    : "<c-e>",
        \ }

    autocmd! FileType ctrlsf call s:ctrlsf_settings()
    function! s:ctrlsf_settings()
        nmap <buffer> <c-j> <c-w>p
        nmap <buffer> <c-k> <c-e>p
    endfunction
endif
if count(s:plugin_groups, 'nerdtree')
    nmap <leader>nt :NERDTreeToggle<cr>
    nmap <F12> :NERDTreeToggle<cr>
    let NERDTreeWinSize=32
    let NERDTreeWinPos="right"
    let NERDTreeShowHidden=1
    let NERDTreeMinimalUI=1
    let NERDTreeAutoDeleteBuffer=1
    let NERDTreeShowBookmarks=1
    let NERDTreeShowLineNumbers=1
    let NERDTreeShowHidden=1
endif
if count(s:plugin_groups, 'clang_complete')
    let g:clang_use_library=1
    if s:os_windows
        let g:clang_library_path = 'C:\LLVM\bin'
    elseif s:os_linux
        let g:clang_library_path = '/usr/lib/llvm-3.8/lib'
    endif
    let g:clang_auto_select=1
    "let g:clang_complete_macros=1
    set completeopt=menu,longest
    let g:clang_complete_auto=1     " automatically complete after -> . ::
    "let g:clang_hl_errors=0         " highlight the warnings and error the same way clang does it
    let g:clang_complete_copen=0    " open quickfix window on error
    let g:clang_periodic_quickfix=0 " periodically update the quickfix window
    let g:clang_snippets=0
    let g:clang_close_preview=1
    let g:clang_user_options='-stdlib=libc++ -std=c++11'
endif
if count(s:plugin_groups, 'YouCompleteMe') "{{{
    nnoremap <Leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <F3> :YcmCompleter GoToDefinitionElseDeclaration<CR>
    nnoremap <leader>je :YcmCompleter GoToDeclaration<CR>
    let g:ycm_key_list_select_completion=['<c-n>']
    "let g:ycm_key_list_select_completion = ['<Down>']
    let g:ycm_key_list_previous_completion=['<c-p>']
    "let g:ycm_key_list_previous_completion = ['<Up>']
    let g:ycm_server_use_vim_stdout = 1
    "let g:ycm_server_log_level = 'debug'
    let g:ycm_global_ycm_extra_conf = g:config_dir . '/lib/.ycm_extra_conf.py'   "set default .ycm_extra_conf.py
    let g:ycm_confirm_extra_conf=0
    let g:ycm_collect_identifiers_from_tag_files = 1                      "use tag files
    let g:ycm_cache_omnifunc=0                                            " disable cache
    let g:ycm_seed_identifiers_with_syntax=1
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_min_num_of_chars_for_completion=3
    let g:ycm_collect_identifiers_from_comments_and_strings = 0
    let g:ycm_autoclose_preview_window_after_insertion = 0
    let g:ycm_autoclose_preview_window_after_completion = 0
endif "}}}
if count(s:plugin_groups, 'nerdcommenter')
    let g:NERDCreateDefaultMappings = 0
    let g:NERDRemoveExtraSpaces = 1
    let g:NERDDefaultAlign = 'left'
    let g:NERDCustomDelimiters = {
                \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'cpp': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'go': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'qml': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ }
    nmap <A-/> <plug>NERDCommenterToggle
    vmap <A-/> <plug>NERDCommenterToggle gv
    nmap <leader>cc <plug>NERDCommenterToggle
    vmap <leader>cc <plug>NERDCommenterToggle gv
endif
if count(s:plugin_groups, 'vim-indent-guides')
    let g:indent_guides_enable_on_vim_startup=0
    let g:indent_guides_start_level=2
    let g:indent_guides_guide_size=1
    :nmap <silent> <Leader>i <Plug>IndentGuidesToggle
endif
if count(s:plugin_groups, 'vim-easymotion')
    let g:EasyMotion_smartcase = 0
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    nmap s <Plug>(easymotion-s)
    nmap S <Plug>(easymotion-s2)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
endif
if count(s:plugin_groups, 'gen_tags.vim')
    "let g:gtags_split = 'v'
    "let g:ctags_opts = '--language-force=c++'
    let g:ctags_opts = 'ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
endif
if count(s:plugin_groups, 'ag.vim')
    let g:ag_prg='ag --vimgrep --smart-case'
    let g:ag_working_path_mode="r"
    let g:ag_highlight=1
endif
if count(s:plugin_groups, 'ack.vim')
endif
if count(s:plugin_groups, 'vim-easygrep')
    "set grepprg=ag\ --smart-case
    "set grepprg=ack\ --smart-case
    "set grepprg=grep\ --smart-case

    let g:EasyGrepCommand = 0
    let g:EasyGrepJumpToMatch=0
    let g:EasyGrepRecursive = 1
    let g:EasyGrepIgnoreCase = 1
    let g:EasyGrepFilesToExclude=".svn,.git,*.pyc,*.bak,cscope.*,*.a,*.o,*.d,*.lst,tags,GTAGS,GRTAGS,GPATH"
    "let g:EasyGrepFilesToExclude=''
endif
if count(s:plugin_groups, 'vim-markdown')
    let g:vim_markdown_folding_disabled = 1
endif
if count(s:plugin_groups, 'vim-fswitch')
    map <silent> <Leader>h <ESC>:FSHere<CR>
endif
if count(s:plugin_groups, 'ultisnips')
    let g:UltiSnipsSnippetDirectories=["mysnippets"]
    let g:UltiSnipsExpandTrigger="<leader><tab>"
    let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
    let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
endif
if count(s:plugin_groups, 'fastfold')
	let g:tex_fold_enabled=1
	let g:vimsyn_folding='af'
	let g:xml_syntax_folding = 1
	let g:php_folding = 1
	let g:perl_fold = 1
endif
" }}}
