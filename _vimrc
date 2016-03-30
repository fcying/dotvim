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

let s:usePlug = 1
let s:useYCM  = 0
let mapleader = ","

if has('gui_running')
    let s:useGUI=1
else
    let s:useGUI=0
endif

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

if s:useGUI > 0
    set guioptions -=T
    set guioptions -=m
endif
set guifont=Consolas:h11
set wildmenu
set mouse=a
set t_Co=256
set ttyfast     " when will this cause problems?
autocmd GUIEnter * set vb t_vb=       "close beep
autocmd VimEnter * set shellredir=>

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

"delete space, delete
nnoremap <leader>ds :%s/\s\+$//
nnoremap <leader>dm :%s/

"set langmenu=zh_CN.UTF-8
"set helplang=cn
set encoding=utf-8
"set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set fileformat=dos
set ffs=dos,unix,mac

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

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set nopaste
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
set virtualedit=onemore     "onemore all

set foldmethod=marker
set nofoldenable

"autocomplete
set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"


"Plugin============================================================================================
filetype off " required!

let &runtimepath = &runtimepath . ',' . g:config_dir . '/myBundle'

if s:usePlug
let g:plug_threads=5
let g:plug_retries=5
call plug#begin(g:config_dir . '/bundle')
Plug g:config_dir . '/myBundle/FencView.vim'
    let g:fencview_autodetect = 1
    let g:fencview_checklines = 10
Plug  'adah1972/tellenc'
Plug  'Mizuchi/STL-Syntax'
Plug  'moll/vim-bbye'
    :nnoremap <Leader>bd :Bdelete<CR>
Plug  'Raimondi/delimitMate'
    let delimitMate_autoclose = 1
    let delimitMate_expand_cr = 1
"Plug  'SirVer/ultisnips'
Plug  'kien/ctrlp.vim'
    let g:ctrlp_working_path_mode = 'a'   "ra c
Plug  'terryma/vim-multiple-cursors'
Plug  'Shougo/unite.vim'
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
      imap <buffer> <C-j>   <Plug>(unite_select_next_line)
      imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
    endfunction
Plug  'Shougo/neomru.vim'
function! BuildVimproc(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force || a:info.status == 'updated'
        if WINDOWS()
            !tools\update-dll-mingw
        elseif LINUX()
            !make
        endif
    endif
endfunction
Plug 'Shougo/vimproc.vim', { 'do': function('BuildVimproc') }
Plug 'Shougo/vimfiler'
    let g:vimfiler_as_default_explorer = 1
Plug  'kshenoy/vim-signature'
Plug  'majutsushi/tagbar'
    let g:tagbar_ctags_bin = g:config_dir . '/lib/ctags.exe'
    let tagbar_left=1
    nnoremap <silent><Leader>tt :TagbarToggle<CR>
    let tagbar_width=32
    let g:tagbar_compact=1
    let g:tagbar_autopreview=0
    "let g:tagbar_autofocus = 1
    "let g:tagbar_autoclose = 1
    "autocmd FileType c,cpp,h nested :TagbarOpen
"Plug  'scrooloose/syntastic'
    let g:syntastic_always_populate_loc_list = 0
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_enable_signs=1
if s:useYCM == 0
    Plug  'Shougo/neocomplete.vim'
    Plug  'Rip-Rip/clang_complete'
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

    "clang_complete
    nmap <F3> <C-]>
    let g:clang_use_library=1
    let g:clang_library_path=g:config_dir . "/lib"
    let g:clang_auto_select=1
    "let g:clang_complete_macros=1
    set completeopt=menu,longest
    let g:clang_complete_auto=1     " automatically complete after -> . ::
    "let g:clang_hl_errors=0         " highlight the warnings and error the same way clang does it
    let g:clang_complete_copen=0    " open quickfix window on error
    let g:clang_periodic_quickfix=0 " periodically update the quickfix window
    let g:clang_snippets=0
    let g:clang_close_preview=1
    "let g:clang_user_options='-stdlib=libc++ -std=c++11'
else
    "Plug  'snakeleon/YouCompleteMe-x64'
    Plug 'Valloric/YouCompleteMe', { 'do': 'git submodule update --init --recursive'  }
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
Plug  'a.vim'
    map <leader>h <ESC>:A<CR>
    map <leader>sh <ESC>:AS<CR>
Plug  'bling/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#show_buffers = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#fnamemod = ':p:.'
Plug  'scrooloose/nerdtree'
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
Plug  'scrooloose/nerdcommenter'
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
Plug  'nathanaelkane/vim-indent-guides'
    let g:indent_guides_enable_on_vim_startup=0
    let g:indent_guides_start_level=2
    let g:indent_guides_guide_size=1
    :nmap <silent> <Leader>i <Plug>IndentGuidesToggle
Plug  'Lokaltog/vim-easymotion'
    let g:EasyMotion_smartcase = 0
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    nmap s <Plug>(easymotion-s)
    nmap S <Plug>(easymotion-s2)
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
Plug  'mileszs/ack.vim'
Plug  'rking/ag.vim'
Plug  'dkprice/vim-easygrep'
    "set grepprg=ag\ --smart-case
    "set grepprg=ack\ --smart-case
    "set grepprg=grep\ --smart-case

    let g:EasyGrepCommand = 0
    let g:EasyGrepJumpToMatch=0
    let g:EasyGrepRecursive = 1
    let g:EasyGrepIgnoreCase = 1
    let g:EasyGrepFilesToExclude=".svn,.git,*.pyc,*.bak,cscope.*,*.a,*.o,*.d,*.lst,tags"
    "let g:EasyGrepFilesToExclude=''

    "ag.vim
    let g:ag_prg='ag --vimgrep --smart-case'
    let g:ag_working_path_mode="r"
    let g:ag_highlight=1

    "ack.vim
    "let g:agprg='ack --smart-case'
Plug  'autohotkey-ahk'
Plug  'vim-AHKcomplete'
call plug#end()
endif
filetype plugin on              " required
filetype indent on
syntax on

