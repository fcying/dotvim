set nocompatible
let mapleader=","

let s:useYCM=0

if has('gui_running')
    let s:useGUI=1
else
    let s:useGUI=0
endif

" windows like
behave mswin        "set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
vnoremap <C-X>      "+x
vnoremap <C-C>      "+y
map      <C-V>      "+gP
cmap     <C-V>      <C-R>+
" Use CTRL-G u to have CTRL-Z only undo the paste.
exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
noremap  <C-Q> <C-V>
noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>
noremap  <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggV

if s:useGUI > 0
    set guioptions -=T
    set guioptions -=m
endif
set guifont=Consolas:h11
set wildmenu
set mouse=a
autocmd GUIEnter * set vb t_vb=       "close beep
set ttyfast     " when will this cause problems?
autocmd VimEnter * set shellredir=>

"set columns=135
"set lines=50
"winpos 620 45
au GUIEnter * simalt ~x

" Easier moving in tabs and windows
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" Wrapped lines goes down/up to next row, rather than next line in file
map j gj
map k gk

" Visual shifting (does not exit Visual mode)
vmap < <gv
vmap > >gv

"delete space
nnoremap <leader>ds :%s/\s\+$//<CR>

"set langmenu=zh_CN.UTF-8
"set helplang=cn
"set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformat=dos
set ffs=dos,unix,mac

set scrolloff=3
set hidden
"set noswapfile
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
set path=.,../inc,../src,
let $PATH = $VIM . ';' . $PATH


set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nopaste
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
set backspace=indent,eol,start whichwrap+=<,>,[,]
set iskeyword -=-
set iskeyword -=.
set iskeyword -=#
"set cursorline
"set cursorcolumn
set virtualedit=onemore     "onemore all

autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ee :e $MYVIMRC<CR>

if filereadable($VIM . '/vimrc')
  set tags=./tags,tags
endif

set foldmethod=syntax
set nofoldenable

"autocomplete
set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"
"imap <expr> <CR> pumvisible() ? "\<c-y>" : "<CR>"
inoremap <expr> <TAB>      pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB>    pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"



" vundle
filetype off " required!
set rtp+=$VIM/bundle/Vundle.vim

"set rtp+=$VIM/bundle/MyCIndent

set rtp+=$VIM/bundle/FencView.vim
    let g:fencview_autodetect = 1
    let g:fencview_checklines = 10

if s:useYCM > 0
set rtp+=$VIM/bundle/ycm
    let g:ycm_server_use_vim_stdout = 1
    let g:ycm_server_log_level = 'debug'
    let g:ycm_global_ycm_extra_conf = 'd:/tools/Vim/.ycm_extra_conf.py'   "set default .ycm_extra_conf.py
    let g:ycm_confirm_extra_conf=0
    nnoremap <Leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    let g:ycm_collect_identifiers_from_tag_files = 1                      "use tag files
    let g:ycm_cache_omnifunc=0                                            " disable cache
    let g:ycm_seed_identifiers_with_syntax=1
    let g:ycm_complete_in_comments = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 0
endif

call vundle#begin($VIM . '/bundle/')

Plugin 'jonathanfilip/vim-lucius'
    let g:lucius_style = 'light'

Plugin 'VundleVim/Vundle.vim'
Plugin 'adah1972/tellenc'
Plugin 'Mizuchi/STL-Syntax'
"Plugin 'fholgado/minibufexpl.vim'

Plugin 'moll/vim-bbye'
    :nnoremap <Leader>bd :Bdelete<CR>

Plugin 'Raimondi/delimitMate'
    let delimitMate_autoclose = 1
    let delimitMate_expand_cr = 1

"Plugin 'SirVer/ultisnips'

Plugin 'kien/ctrlp.vim'
    let g:ctrlp_working_path_mode = 'a'   "ra c

Plugin 'terryma/vim-multiple-cursors'

Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/vimproc.vim'

Plugin 'Shougo/unite.vim'
    nnoremap <leader>uf :Unite file<CR>
    nnoremap <leader>ub :Unite file<CR>
    nnoremap <leader>ur :Unite file_rec<CR>
    nnoremap <leader>up :Unite file_rec/async<CR>

Plugin 'kshenoy/vim-signature'

"Plugin 'majutsushi/tagbar'
    let g:tagbar_ctags_bin = $VIM . '/ctags.exe'
    let tagbar_left=1
    nnoremap <Leader>tt :TagbarToggle<CR>
    let tagbar_width=32
    let g:tagbar_compact=1
    "let g:tagbar_autofocus = 1
    "let g:tagbar_autoclose = 1
    "autocmd FileType c,cpp,h nested :TagbarOpen

"Plugin 'scrooloose/syntastic'
    "let g:syntastic_ignore_files=[".*\.py$"]
    "set statusline+=%#warningmsg#
    "set statusline+=%{SyntasticStatuslineFlag()}
    "set statusline+=%*

    let g:syntastic_always_populate_loc_list = 0
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_enable_signs=1

if s:useYCM == 0
Plugin 'Shougo/neocomplete.vim'
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_auto_select = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

Plugin 'Rip-Rip/clang_complete'
    let g:clang_use_library=1
    let g:clang_library_path=$VIM
    let g:clang_auto_select=1
    let g:clang_complete_copen = 1
    "let g:clang_complete_macros=1
endif

Plugin 'a.vim'
    map <leader>h <ESC>:A<CR>
    map <leader>sh <ESC>:AS<CR>

Plugin 'bling/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#show_buffers = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#fnamemod = ':p:.'

Plugin 'scrooloose/nerdtree'
    nmap <leader>nt :NERDTreeToggle<cr>
    let NERDTreeWinSize=32
    let NERDTreeWinPos="right"
    let NERDTreeShowHidden=1
    let NERDTreeMinimalUI=1
    let NERDTreeAutoDeleteBuffer=1
    let NERDTreeShowBookmarks=1
    let NERDTreeShowLineNumbers=1
    let NERDTreeShowHidden=1

Plugin 'scrooloose/nerdcommenter'
    let NERD_c_alt_style=1
    let NERD_cpp_alt_style=1
    let g:NERDCustomDelimiters = {
        \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
        \ 'cpp': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' }
    \ }
    nmap <A-/> <plug>NERDCommenterInvert
    vmap <A-/> <plug>NERDCommenterInvert gv
    nmap <leader>cc <plug>NERDCommenterInvert
    vmap <leader>cc <plug>NERDCommenterInvert gv

Plugin 'nathanaelkane/vim-indent-guides'
    let g:indent_guides_enable_on_vim_startup=0
    let g:indent_guides_start_level=2
    let g:indent_guides_guide_size=1
    :nmap <silent> <Leader>i <Plug>IndentGuidesToggle

Plugin 'Lokaltog/vim-easymotion'
    let g:EasyMotion_smartcase = 0
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    nmap s <Plug>(easymotion-s)
    nmap S <Plug>(easymotion-s2)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)

Plugin 'dkprice/vim-easygrep'

call vundle#end()            " required
filetype plugin on    " required
filetype indent on
syntax on

"colorscheme lucius
