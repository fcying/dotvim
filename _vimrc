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

if g:os_windows
    let g:config_dir = $HOME . '/.vim'
else
    let g:config_dir = '~/.vim'
endif
"}}}



" ============================================================================
" basic settings {{{
" ============================================================================
let mapleader = ";"

if filereadable($HOME . '/.vimrc.local')
    execute 'source ' . $HOME .'/.vimrc.local'
endif

"autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ee :e $MYVIMRC<CR>

"behave mswin        "set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

if !has('nvim')
    if g:os_windows
        set renderoptions=type:directx,level:0.50,
                \gamma:1.0,contrast:0.0,geom:1,renmode:5,taamode:1
    endif
endif

if g:os_linux
    set clipboard=exclude:.*    "setup clipboard make startup slow
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
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif
set wildmenu
set wildmode=longest:full,full
set wildignore=*.bak,*.o,*.e,*~,*.swp
set ttyfast     " when will this cause problems?
autocmd GUIEnter * set vb t_vb=       "close beep
set noerrorbells
autocmd VimEnter * set shellredir=>

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
set indentexpr=""
set cinkeys-=0#
inoremap # X#

set number
set ruler
set laststatus=2
"set noshowmatch
set nolist
set wrap
set showcmd
"set cmdheight=1
set backspace=indent,eol,start whichwrap+=<,>,[,]
set iskeyword -=-
set iskeyword -=.
set iskeyword -=#
set virtualedit=onemore        "onemore all
"set paste
set lazyredraw

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

if g:os_windows
    set tags=tags
else
    set tags=tags
endif
nmap <c-]> :tj <c-r><c-w><CR>
nmap <F3> <c-]>
nmap <F4> <C-o>

command! -nargs=0 UpdatePlugin call s:fcy_update_plugin()
function! s:fcy_update_plugin()
    PlugUpgrade
    PlugUpdate
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

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType autohotkey setl omnifunc=ahkcomplete#Complete

au BufNewFile,BufRead *.qml set filetype=qml
au BufNewFile,BufRead *.conf set filetype=conf

" find project file
let s:vimconf_path = findfile(".vimconf", ".;")
if s:vimconf_path != ""
    exec 'source ' . s:vimconf_path
endif
" }}}



" ============================================================================
" plugin {{{
" ============================================================================
function! Fcy_source_rc(file) abort
    "if filereadable(g:config_dir . '/' . a:file)
        execute 'source ' . g:config_dir . '/' . a:file
    "endif
endf

function! s:load_plugins() abort
    for plugin in g:plugins
        if len(plugin) == 2
            exec "Plug " . "'" . plugin[0] . "', " . string(plugin[1])
        else
            exec "Plug " . "'" . plugin[0] . "'"
        endif
    endfor
endfunction


"ncm ycm deoplete neocomplte
if !exists('g:complete_func')
    let g:complete_func = 'neocomplte'
endif

let g:plugins = []
call Fcy_source_rc('_vimrc.plug.before')
call add(g:plugins, ['mbbill/fencview'])
call add(g:plugins, ['adah1972/tellenc'])
call add(g:plugins, ['sheerun/vim-polyglot'])   "A solid language pack for Vim.
call add(g:plugins, ['bogado/file-line'])
call add(g:plugins, ['itchyny/lightline.vim'])
call add(g:plugins, ['roxma/vim-paste-easy'])
call add(g:plugins, ['t9md/vim-choosewin', {'on':'<Plug>(choosewin)'}])
call add(g:plugins, ['moll/vim-bbye', {'on':'Bdelete'}])
call add(g:plugins, ['MattesGroeger/vim-bookmarks'])
call add(g:plugins, ['thinca/vim-ref'])
call add(g:plugins, ['terryma/vim-expand-region'])
call add(g:plugins, ['terryma/vim-multiple-cursors'])
call add(g:plugins, ['dyng/ctrlsf.vim'])
call add(g:plugins, ['easymotion/vim-easymotion'])
call add(g:plugins, ['derekwyatt/vim-fswitch'])
call add(g:plugins, ['nathanaelkane/vim-indent-guides', {'on':'<Plug>IndentGuidesToggle'}])
call add(g:plugins, ['scrooloose/nerdtree', {'on':'NERDTreeToggle'}])
call add(g:plugins, ['scrooloose/nerdcommenter', {'on':'<Plug>NERDCommenterToggle'}])
call add(g:plugins, ['majutsushi/tagbar', {'on':'TagbarToggle'}])
call add(g:plugins, ['xolox/vim-session'])
call add(g:plugins, ['xolox/vim-misc'])

if g:os_windows 
    call add(g:plugins, ['Yggdroot/LeaderF', {'do': '.\install.bat'}])
else
    call add(g:plugins, ['Yggdroot/LeaderF', {'do': './install.sh'}])
endif
"call add(g:plugins, ['Shougo/denite.nvim'])
"call add(g:plugins, ['nixprime/cpsm', {'do':'./install.sh'}])
"call add(g:plugins, ['Shougo/unite.vim'])
"call add(g:plugins, ['Shougo/unite-outline'])
"call add(g:plugins, ['Shougo/neoyank.vim'])
"call add(g:plugins, ['Shougo/neomru.vim'])
"call add(g:plugins, ['hewes/unite-gtags'])
call add(g:plugins, ['Shougo/vimproc.vim', {'do':function('BuildVimproc')}])
"call add(g:plugins, ['Shougo/vimfiler'])
call add(g:plugins, ['Shougo/vimshell', {'on': 'VimShell'}])
call add(g:plugins, ['lambdalisue/gina.vim', {'on': 'Gina'}])

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
call add(g:plugins, ['jsfaint/gen_tags.vim', {'on': ['GenCtags', 'ClearCtags!']}])
if g:complete_func == 'deoplete'
    if has('nvim')
       call add(g:plugins, ['Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}])
    else
       call add(g:plugins, ['Shougo/deoplete.nvim'])
       call add(g:plugins, ['roxma/nvim-yarp'])
       call add(g:plugins, ['roxma/vim-hug-neovim-rpc'])
    endif
elseif g:complete_func == 'ncm'
    if !has('nvim')
        call add(g:plugins, ['roxma/vim-hug-neovim-rpc'])
    endif
    call add(g:plugins, ['roxma/ncm-clang'])
    call add(g:plugins, ['roxma/nvim-completion-manager'])
    "call add(g:plugins, ['autozimu/LanguageClient-neovim', {'do': ':UpdateRemotePlugins'}])
    "let g:LanguageClient_autoStart = 1
    "let g:LanguageClient_serverCommands = {
    "    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    "    \ 'c': ['c', 'run', 'nightly', 'c'],
    "    \ }
elseif g:complete_func == 'ycm'
    call add(g:plugins, ['Valloric/YouCompleteMe'])
else
    if has('lua')
      call add(g:plugins, ['Shougo/neocomplete'])
      call add(g:plugins, ['Shougo/neoinclude.vim'])
      call add(g:plugins, ['Shougo/neco-syntax'])
      call add(g:plugins, ['Shougo/neco-vim'])
    endif
endif

call add(g:plugins, ['nsf/gocode', {'do':function('GetGoCode'), 'for':'go'}])
call add(g:plugins, ['dgryski/vim-godef', {'for':'go'}])
call add(g:plugins, ['vim-scripts/autohotkey-ahk', {'for':'autohotkey'}])
call add(g:plugins, ['huleiak47/vim-AHKcomplete', {'for':'autohotkey'}])
call add(g:plugins, ['godlygeek/tabular', {'for':'markdown'}])
call add(g:plugins, ['plasticboy/vim-markdown', {'for':'markdown'}])

"color
"call add(g:plugins, ['altercation/vim-colors-solarized'])
call add(g:plugins, ['fcying/vim-colors-solarized'])
call add(g:plugins, ['tomasr/molokai'])
call add(g:plugins, ['icymind/NeoSolarized'])



let g:plugin_dir = g:config_dir . '/plugged'
let g:plugin_manager_dir = g:config_dir . '/.cache/vim-plug'
if filereadable(expand(g:plugin_manager_dir . '/autoload/plug.vim')) == 0
    if executable('curl')
        silent exec '!curl -fLo '
                    \ . g:plugin_manager_dir . '/autoload/plug.vim'
                    \ . ' --create-dirs '
                    \ . 'https://raw.githubusercontent.com/'
                    \ . 'junegunn/vim-plug/master/plug.vim'
    else
        echohl WarningMsg
        echom 'You need install curl!'
        echohl None
    endif
endif
exec 'set runtimepath+=' . g:plugin_manager_dir
call plug#begin(expand(g:plugin_dir))
call s:load_plugins()
call plug#end()

filetype plugin indent on
syntax enable

call Fcy_source_rc('_vimrc.plug.after')
"}}}



" ============================================================================
" color {{{
" ============================================================================
if g:os_windows
    let s:colorscheme = 'NeoSolarized'
else
    let s:colorscheme = 'solarized'
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

if s:colorscheme == 'solarized'
    let g:solarized_termcolors=256
    set t_Co=256
    set background=light
    if g:os_windows && !has('gui_running') && !empty($CONEMUBUILD)
        let &t_AB="\e[48;5;%dm"
        let &t_AF="\e[38;5;%dm"
    endif
elseif s:colorscheme == 'molokai'
    let g:rehash256 = 1
    let g:molokai_original = 1
    set background=dark
elseif s:colorscheme == 'NeoSolarized'    
    set termguicolors
    let g:neosolarized_vertSplitBgTrans = 0
    set background=light
    set t_8b=[48;2;%lu;%lu;%lum    
    set t_8f=[38;2;%lu;%lu;%lum
else    
endif

exec 'colorscheme ' . s:colorscheme
" }}}
