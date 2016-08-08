set nocompatible

"detect OS {{{
function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return (has('win16') || has('win32') || has('win64'))
endfunction
"}}}

if WINDOWS()
    let g:config_dir = $VIM
elseif LINUX()
    let g:config_dir = '~/.vim'
endif

let mapleader   = ","
let s:useVendor = 1
let s:useYCM    = 0

if has('gui_running')
    let s:useGUI=1
else
    let s:useGUI=0
endif

let s:plugin_groups = []
call add(s:plugin_groups, 'fencview')
call add(s:plugin_groups, 'tellenc')
call add(s:plugin_groups, 'STL-Syntax')
call add(s:plugin_groups, 'vim-bbye')
call add(s:plugin_groups, 'delimitMate')
"call add(s:plugin_groups, 'ultisnips')
call add(s:plugin_groups, 'ctrlp')
call add(s:plugin_groups, 'ctrlsf')
call add(s:plugin_groups, 'vim-multiple-cursors')
call add(s:plugin_groups, 'unite')
call add(s:plugin_groups, 'neomru')
call add(s:plugin_groups, 'vimproc')
call add(s:plugin_groups, 'vimfiler')
call add(s:plugin_groups, 'vim-signature')
call add(s:plugin_groups, 'tagbar')
"call add(s:plugin_groups, 'syntastic')
if s:useYCM
    call add(s:plugin_groups, 'YouCompleteMe')
else
    if has('nvim')
        call add(s:plugin_groups, 'deoplete')
    else
        call add(s:plugin_groups, 'neocomplete')
    endif
    "call add(s:plugin_groups, 'vim-clang')
    call add(s:plugin_groups, 'clang_complete')
endif
call add(s:plugin_groups, 'vim-fswitch')
call add(s:plugin_groups, 'vim-airline')
call add(s:plugin_groups, 'nerdtree')
call add(s:plugin_groups, 'nerdcommenter')
call add(s:plugin_groups, 'vim-indent-guides')
call add(s:plugin_groups, 'vim-easymotion')
call add(s:plugin_groups, 'ack.vim')
call add(s:plugin_groups, 'ag.vim')
call add(s:plugin_groups, 'vim-easygrep')
call add(s:plugin_groups, 'autohotkey-ahk')
call add(s:plugin_groups, 'vim-AHKcomplete')

autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ee :e $MYVIMRC<CR>

behave mswin        "set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>
noremap  <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggV

if s:useGUI
    set guioptions -=T
    set guioptions -=m
    set mouse=a
    set guifont=Consolas:h11
    au GUIEnter * simalt ~x
else
    set mouse=
endif
set wildmenu
set t_Co=256
set ttyfast     " when will this cause problems?
autocmd GUIEnter * set vb t_vb=       "close beep
autocmd VimEnter * set shellredir=>

if LINUX()
    colorscheme desert
endif


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

"delete space, delete
nnoremap <leader> :%s/\s\+$//<CR>
nnoremap <leader>dm :%s/<CR>

"set langmenu=zh_CN.UTF-8
"set helplang=cn
set encoding=utf-8
"set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set fileformat=dos
if WINDOWS()
    set ffs=dos,unix,mac
else
    set ffs=unix,dos,mac
endif

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
if WINDOWS()
    let $PATH = g:config_dir . '/lib' . ';' . $PATH
elseif LINUX()
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
"set cmdheight=1
set backspace=indent,eol,start whichwrap+=<,>,[,]
set iskeyword -=-
set iskeyword -=.
set iskeyword -=#
set virtualedit=onemore        "onemore all

set foldmethod=marker
set nofoldenable

"set paste

"autocomplete
"set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

set tags+=./tags
nmap <F3> <C-]>
nmap <Leader>cr :!ctags -R --c++-kin=+p+l+x+c+d+e+f+g+m+n+s+t+u+v --fields=+liaS --extra=+q --language-force=c++<CR>
nmap <Leader>co :!ctags -R --language-force=c++<CR>
nmap <Leader>tn :tnext<CR>
nmap <Leader>tp :tprevious<CR>

"Plugin============================================================================================
filetype off " required!

let &runtimepath = &runtimepath . ',' . g:config_dir . '/bundle/neobundle.vim'

if s:useVendor
call neobundle#begin(g:config_dir . '/bundle')
NeoBundleFetch 'https://github.com/Shougo/neobundle.vim'
if count(s:plugin_groups, 'fencview')
    NeoBundle 'mbbill/fencview'
    let g:fencview_autodetect = 1
    let g:fencview_checklines = 10
endif
if count(s:plugin_groups, 'tellenc')
    NeoBundle  'adah1972/tellenc'
endif
if count(s:plugin_groups, 'STL-Syntax')
    NeoBundle  'Mizuchi/STL-Syntax'
endif
if count(s:plugin_groups, 'vim-bbye')
    NeoBundle  'moll/vim-bbye'
    :nnoremap <Leader>bd :Bdelete<CR>
endif
if count(s:plugin_groups, 'delimitMate')
    NeoBundle  'Raimondi/delimitMate'
    let delimitMate_autoclose = 1
    let delimitMate_expand_cr = 1
endif
if count(s:plugin_groups, 'ultisnips')
    NeoBundle  'SirVer/ultisnips'
endif
if count(s:plugin_groups, 'ctrlp.vim')
    NeoBundle  'kien/ctrlp.vim'
    let g:ctrlp_working_path_mode = 'a'   "ra c
endif
if count(s:plugin_groups, 'ctrlsf.vim')
    NeoBundle 'dyng/ctrlsf.vim'
    nnoremap <Leader>sp :CtrlSF<CR>
endif
if count(s:plugin_groups, 'vim-multiple-cursors')
    NeoBundle  'terryma/vim-multiple-cursors'
endif
if count(s:plugin_groups, 'unite')
    NeoBundle  'Shougo/unite.vim'
    let g:unite_data_directory=g:config_dir . '/.cache/unite'
    let g:unite_enable_start_insert=0
    let g:unite_source_history_yank_enable=1
    "let g:unite_source_rec_max_cache_files=5000
    let g:unite_force_overwrite_statusline=1
    " Using ag as recursive command.
    let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']

    nnoremap <leader>f :Unite file buffer<CR>
    nnoremap <leader>r :Unite file_rec/async<cr>
    nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>

    autocmd FileType unite call s:unite_settings()
    function! s:unite_settings()
        nmap <buffer> Q <plug>(unite_exit)
        nmap <buffer> <esc> <plug>(unite_exit)
        imap <buffer> <esc> <plug>(unite_exit)
        imap <buffer> <C-j> <Plug>(unite_select_next_line)
        imap <buffer> <C-k> <Plug>(unite_select_previous_line)
    endfunction
endif
if count(s:plugin_groups, 'neomru')
    NeoBundle  'Shougo/neomru.vim'
endif
if count(s:plugin_groups, 'vimproc')
    NeoBundle 'Shougo/vimproc.vim', {
        \ 'build' : {
        \     'windows' : 'tools\\update-dll-mingw',
        \     'cygwin' : 'make -f make_cygwin.mak',
        \     'mac' : 'make',
        \     'linux' : 'make',
        \     'unix' : 'gmake',
        \    },
        \ }
endif
if count(s:plugin_groups, 'vimfiler')
    NeoBundle 'Shougo/vimfiler'
    let g:vimfiler_as_default_explorer = 1
endif
if count(s:plugin_groups, 'vim-signature')
    NeoBundle  'kshenoy/vim-signature'
endif
if count(s:plugin_groups, 'tagbar')
    NeoBundle  'majutsushi/tagbar'
    "if WINDOWS()
        "let g:tagbar_ctags_bin = g:config_dir . '/lib/ctags.exe'
    "endif
    let tagbar_left=1
    nnoremap <silent><Leader>tt :TagbarToggle<CR>
    let tagbar_width=32
    let g:tagbar_compact=1
    let g:tagbar_autopreview=0
    "let g:tagbar_autofocus = 1
    "let g:tagbar_autoclose = 1
    "autocmd FileType c,cpp,h nested :TagbarOpen
endif
if count(s:plugin_groups, 'syntastic')
    NeoBundle  'scrooloose/syntastic'
    let g:syntastic_always_populate_loc_list = 0
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_enable_signs=1
endif
if count(s:plugin_groups, 'neocomplete')
    NeoBundle  'Shougo/neocomplete.vim'
    let s:hooks = neobundle#get_hooks("neocomplete")
    function! s:hooks.on_source(bundle) abort
        "let g:neocomplete#data_directory='~/.cache/neocomplete'
        let g:acp_enableAtStartup = 0
        let g:neocomplete#enable_at_startup = 1
        " Use smartcase.
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#enable_camel_case = 1
        "let g:neocomplete#enable_ignore_case = 1
        let g:neocomplete#enable_fuzzy_completion = 1
        " Set minimum syntax keyword length.
        let g:neocomplete#sources#syntax#min_keyword_length = 3
        let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

        let g:neocomplete#enable_auto_delimiter = 1

        " Define keyword.
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns._ = '\h\k*(\?'

        let g:neocomplete#enable_auto_select = 1

        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif

        let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplete#sources#omni#input_patterns.java ='[^. \t0-9]\.\w*'
        let g:neocomplete#force_omni_input_patterns = {}
        "let g:neocomplete#force_omni_input_patterns.java = '^\s*'
        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><C-y>  neocomplete#close_popup()
        inoremap <expr><C-e>  neocomplete#cancel_popup()
    endfunction
endif
if count(s:plugin_groups, 'vim-clang')
    NeoBundle 'justmao945/vim-clang'
    if WINDOWS()
        let g:clang_exec='C:/LLVM/bin/clang.exe'
        let g:clang_format_exec = 'C:/LLVM/bin/clang-format.exe'
        let g:clang_gcc_exec = 'C:/msys64/mingw64/bin/gcc.exe'
        let g:clang_vim_exec = 'gvim'
    elseif LINUX()
        let g:clang_exec = 'clang'
        let g:clang_format_exec = 'clang-format'
    endif
    let g:clang_auto = 1
    let g:clang_c_completeopt = 'menuone,preview'
    let g:clang_cpp_completeopt = 'menuone,preview'
    let g:clang_auto_select=1
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
if count(s:plugin_groups, 'clang_complete')
    NeoBundle  'Rip-Rip/clang_complete'
    let g:clang_use_library=1
    if WINDOWS()
        let g:clang_library_path='C:/LLVM/bin'
    elseif LINUX()
        let g:clang_library_path='/usr/lib/llvm-3.8/lib'
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
if count(s:plugin_groups, 'deoplete')
    NeoBundle 'Shougo/deoplete.nvim'
    let s:hooks = neobundle#get_hooks("deoplete.nvim")
    function! s:hooks.on_source(bundle)
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
    endfunction
endif
if count(s:plugin_groups, 'YouCompleteMe')
    NeoBundle 'Valloric/YouCompleteMe'
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
endif
    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType autohotkey setl omnifunc=ahkcomplete#Complete
if count(s:plugin_groups, 'vim-fswitch')
    NeoBundle 'derekwyatt/vim-fswitch'
    map <silent> <Leader>sw <ESC>:FSHere<CR>
endif
if count(s:plugin_groups, 'vim-airline')
    NeoBundle  'bling/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#show_buffers = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#fnamemod = ':p:.'
endif
if count(s:plugin_groups, 'nerdtree')
    NeoBundle  'scrooloose/nerdtree'
    nmap <leader>nt :NERDTreeToggle<cr>
    let NERDTreeWinSize=32
    let NERDTreeWinPos="right"
    let NERDTreeShowHidden=1
    let NERDTreeMinimalUI=1
    let NERDTreeAutoDeleteBuffer=1
    let NERDTreeShowBookmarks=1
    let NERDTreeShowLineNumbers=1
    let NERDTreeShowHidden=1
    let g:NERDTreeDirArrowExpandable = '?'
    let g:NERDTreeDirArrowCollapsible = '?'
endif
if count(s:plugin_groups, 'nerdcommenter')
    NeoBundle  'scrooloose/nerdcommenter'
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
endif
if count(s:plugin_groups, 'vim-indent-guides')
    NeoBundle  'nathanaelkane/vim-indent-guides'
    let g:indent_guides_enable_on_vim_startup=0
    let g:indent_guides_start_level=2
    let g:indent_guides_guide_size=1
    :nmap <silent> <Leader>i <Plug>IndentGuidesToggle
endif
if count(s:plugin_groups, 'vim-easymotion')
    NeoBundle  'Lokaltog/vim-easymotion'
    let g:EasyMotion_smartcase = 0
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    nmap s <Plug>(easymotion-s)
    nmap S <Plug>(easymotion-s2)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
endif
if count(s:plugin_groups, 'ack.vim')
    NeoBundle  'mileszs/ack.vim'
endif
if count(s:plugin_groups, 'ag.vim')
    NeoBundle  'rking/ag.vim'
endif
if count(s:plugin_groups, 'vim-easygrep')
    NeoBundle  'dkprice/vim-easygrep'
    "set grepprg=ag\ --smart-case
    "set grepprg=ack\ --smart-case
    "set grepprg=grep\ --smart-case

    let g:EasyGrepCommand = 0
    let g:EasyGrepJumpToMatch=0
    let g:EasyGrepRecursive = 1
    let g:EasyGrepIgnoreCase = 1
    let g:EasyGrepFilesToExclude=".svn,.git,*.pyc,*.bak,cscope.*,*.a,*.o,*.d,*.lst,tags"
    "let g:EasyGrepFilesToExclude=''
endif
    "ag.vim
    let g:ag_prg='ag --vimgrep --smart-case'
    let g:ag_working_path_mode="r"
    let g:ag_highlight=1
    "ack.vim
    "let g:agprg='ack --smart-case'
if count(s:plugin_groups, 'autohotkey-ahk')
    NeoBundle  'autohotkey-ahk'
endif
if count(s:plugin_groups, 'vim-AHKcomplete')
    NeoBundle  'vim-AHKcomplete'
endif
call neobundle#end()
NeoBundleCheck
endif
filetype plugin indent on              " required
syntax on

