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

"}}}



" ============================================================================
" basic settings {{{
" ============================================================================
if filereadable($HOME . '/.vimrc.before')
    execute 'source ' . $HOME .'/.vimrc.before'
endif

let mapleader = get(g:,'mapleader',';')

if !has('nvim')
    if g:os_windows
        set renderoptions=type:directx,level:0.50,
                \gamma:1.0,contrast:0.0,geom:1,renmode:5,taamode:1
    endif
endif

if g:os_linux
    if !has('nvim')
        set clipboard=exclude:.*    "setup clipboard make startup slow
    endif
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
set wildmenu
set wildmode=longest:full,full
set wildignore=*.bak,*.o,*.e,*~,*.swp
set ttyfast     " when will this cause problems?
autocmd GUIEnter * set vb t_vb=       "close beep
set noerrorbells
autocmd VimEnter * set shellredir=>

"autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ee :e $MYVIMRC<CR>

" Fast saving
nnoremap <C-s> :<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>

" Wrapped lines goes down/up to next row, rather than next line in file
map j gj
map k gk

xnoremap < <gv
xnoremap > >gv|
nnoremap > >>_
nnoremap < <<_

" Start new line
inoremap <S-Return> <C-o>o

"delete space, delete ^M
nnoremap <leader>ds :%s/\s\+$//g<CR>:noh<CR>
nnoremap <leader>dm :%s/\r$//g<CR>:noh<CR>

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
set cindent
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
set lazyredraw
"set paste
set pastetoggle=<F5>

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

"" auto pairs
"inoremap ( ()<ESC>i
"inoremap ) <c-r>=ClosePair(')')<CR>
"inoremap {<CR> {}<ESC>i<CR><c-o><s-o>
"inoremap } <c-r>=ClosePair('}')<CR>
"inoremap [ []<ESC>i
"inoremap ] <c-r>=ClosePair(']')<CR>
""inoremap " <c-r>=CloseSamePair('"')<CR>
""inoremap ' <c-r>=CloseSamePair('''')<CR>
"
"function! CloseSamePair(char)
"    if getline('.')[col('.') - 1] == a:char
"        return "\<Right>"
"    else
"        let l:char=a:char . a:char . "\<Left>"
"        return l:char
"    endif
"endf
"
"function! ClosePair(char)
"    if getline('.')[col('.') - 1] == a:char
"        return "\<Right>"
"    else
"        return a:char
"    endif
"endf

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

" }}}



" ============================================================================
" plugin {{{
" ============================================================================
function! s:load_plugins() abort
    for plugin in g:plug_list
        if len(plugin) == 2
            exec "Plug " . "'" . plugin[0] . "', " . string(plugin[1])
        else
            exec "Plug " . "'" . plugin[0] . "'"
        endif
    endfor
endfunction


"ncm ycm deoplete neocomplte
let g:complete_func = get(g:, 'complete_func', 'neocomplete')

let g:plug_list = []
execute 'source ' . g:config_dir . '/_vimrc.plug.before'
call add(g:plug_list, ['junegunn/vim-plug'])
call add(g:plug_list, ['mbbill/fencview'])
call add(g:plug_list, ['adah1972/tellenc'])
call add(g:plug_list, ['sheerun/vim-polyglot'])   "A solid language pack for Vim.
call add(g:plug_list, ['bogado/file-line'])
"call add(g:plug_list, ['Raimondi/delimitMate'])
call add(g:plug_list, ['jiangmiao/auto-pairs'])
call add(g:plug_list, ['tpope/vim-surround'])
call add(g:plug_list, ['itchyny/lightline.vim'])
call add(g:plug_list, ['roxma/vim-paste-easy'])
"let g:paste_easy_enable = 0
call add(g:plug_list, ['t9md/vim-choosewin', {'on':'<Plug>(choosewin)'}])
call add(g:plug_list, ['moll/vim-bbye', {'on':'Bdelete'}])
call add(g:plug_list, ['MattesGroeger/vim-bookmarks'])
call add(g:plug_list, ['thinca/vim-ref'])
call add(g:plug_list, ['terryma/vim-expand-region'])
call add(g:plug_list, ['terryma/vim-multiple-cursors'])
call add(g:plug_list, ['dyng/ctrlsf.vim'])
call add(g:plug_list, ['easymotion/vim-easymotion'])
call add(g:plug_list, ['derekwyatt/vim-fswitch'])
call add(g:plug_list, ['nathanaelkane/vim-indent-guides', {'on':'<Plug>IndentGuidesToggle'}])
call add(g:plug_list, ['scrooloose/nerdtree', {'on':'NERDTreeToggle'}])
call add(g:plug_list, ['scrooloose/nerdcommenter', {'on':'<Plug>NERDCommenterToggle'}])
call add(g:plug_list, ['majutsushi/tagbar', {'on':'TagbarToggle'}])
call add(g:plug_list, ['xolox/vim-session'])
call add(g:plug_list, ['xolox/vim-misc'])

if g:os_windows 
    call add(g:plug_list, ['Yggdroot/LeaderF', {'do': '.\install.bat'}])
else
    call add(g:plug_list, ['Yggdroot/LeaderF', {'do': './install.sh'}])
endif
"call add(g:plug_list, ['Shougo/denite.nvim'])
"call add(g:plug_list, ['nixprime/cpsm', {'do':'./install.sh'}])
"call add(g:plug_list, ['Shougo/unite.vim'])
"call add(g:plug_list, ['Shougo/unite-outline'])
"call add(g:plug_list, ['Shougo/neoyank.vim'])
"call add(g:plug_list, ['Shougo/neomru.vim'])
"call add(g:plug_list, ['hewes/unite-gtags'])
call add(g:plug_list, ['Shougo/vimproc.vim', {'do':function('BuildVimproc')}])
"call add(g:plug_list, ['Shougo/vimfiler'])
call add(g:plug_list, ['Shougo/vimshell', {'on': 'VimShell'}])
call add(g:plug_list, ['lambdalisue/gina.vim', {'on': 'Gina'}])

if executable('ctags') && executable('global')
    call add(g:plug_list, ['jsfaint/gen_tags.vim'])
endif
if g:complete_func == 'deoplete'
    if has('nvim')
       call add(g:plug_list, ['Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}])
    else
       call add(g:plug_list, ['Shougo/deoplete.nvim'])
       call add(g:plug_list, ['roxma/nvim-yarp'])
       call add(g:plug_list, ['roxma/vim-hug-neovim-rpc'])
    endif
   call add(g:plug_list, ['SpaceVim/deoplete-clang2'])
   call add(g:plug_list, ['zchee/deoplete-jedi', {'for':'python'}])
elseif g:complete_func == 'ncm'
    if !has('nvim')
        call add(g:plug_list, ['roxma/vim-hug-neovim-rpc'])
    else
        call add(g:plug_list, ['autozimu/LanguageClient-neovim', {'do': ':UpdateRemotePlugins'}])
    endif
    call add(g:plug_list, ['roxma/ncm-clang'])
    call add(g:plug_list, ['roxma/nvim-completion-manager'])
elseif g:complete_func == 'ycm'
    call add(g:plug_list, ['Valloric/YouCompleteMe'])
else
    if has('lua')
      call add(g:plug_list, ['Shougo/neocomplete'])
      call add(g:plug_list, ['Shougo/neoinclude.vim'])
      call add(g:plug_list, ['Shougo/neco-syntax'])
      call add(g:plug_list, ['Shougo/neco-vim'])
    endif
endif

call add(g:plug_list, ['nsf/gocode', {'do':function('GetGoCode'), 'for':'go'}])
call add(g:plug_list, ['dgryski/vim-godef', {'for':'go'}])
call add(g:plug_list, ['vim-scripts/autohotkey-ahk', {'for':'autohotkey'}])
call add(g:plug_list, ['huleiak47/vim-AHKcomplete', {'for':'autohotkey'}])
call add(g:plug_list, ['godlygeek/tabular', {'for':'markdown'}])
call add(g:plug_list, ['plasticboy/vim-markdown', {'for':'markdown'}])

"color
"call add(g:plug_list, ['altercation/vim-colors-solarized'])
call add(g:plug_list, ['fcying/vim-colors-solarized'])
call add(g:plug_list, ['tomasr/molokai'])
call add(g:plug_list, ['icymind/NeoSolarized'])



let g:plug_dir = g:config_dir . '/plugged'
if filereadable(expand(g:plug_dir . '/vim-plug/plug.vim')) == 0
    if executable('git')
        let s:first_install=1
        silent exec '!git clone --depth 1 https://github.com/junegunn/vim-plug '
                    \ . g:plug_dir . '/vim-plug'
    else
        echohl WarningMsg
        echom 'You need install git!'
        echohl None
    endif
endif
exec 'source '. g:plug_dir . '/vim-plug/plug.vim'
call plug#begin(expand(g:plug_dir))
call s:load_plugins()
call plug#end()


filetype plugin indent on
syntax enable


" auto install
let g:plug_auto_install = get(g:, 'plug_auto_install', 'false')
if g:plug_auto_install == 'true' || exists("s:first_install")
    let s:plug_list_cache=g:config_dir . '/.cache/plug_list_cache'
    if filereadable(s:plug_list_cache)
        let s:last_plug_list=readfile(s:plug_list_cache, "b")
    else
        let s:last_plug_list=[]
        echom "no plug_list_cache"
    endif
    let s:plug_string=[string(g:plug_list)]
    if s:last_plug_list != s:plug_string
        call writefile(s:plug_string, s:plug_list_cache, "b")
        "call writefile(g:plug_list, s:plug_list_cache, "b")
        echom "update plug_list_cache"
        silent PlugInstall
    endif
endif

execute 'source ' . g:config_dir . '/_vimrc.plug.after'

"}}}

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


if filereadable($HOME . '/.vimrc.after')
    execute 'source ' . $HOME .'/.vimrc.after'
endif

" find project file
let s:vimconf_path = findfile(".vimconf", ".;")
if s:vimconf_path != ""
    exec 'source ' . s:vimconf_path
endif

