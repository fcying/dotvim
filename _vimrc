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
    let g:home_dir = $HOME
elseif LINUX()
    let g:config_dir = '~/.vim'
    let g:home_dir = '~'
endif


" ============================================================================
" Plugins
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
"call add(s:plugin_groups, 'syntastic')
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
"call add(s:plugin_groups, 'vim-airline')
"call add(s:plugin_groups, 'minibufexpl.vim')
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

" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

let mapleader   = ","

if has('gui_running')
    let s:useGUI=1
else
    let s:useGUI=0
endif


"autocmd! bufwritepost _vimrc source $MYVIMRC
nnoremap <leader>ee :e $MYVIMRC<CR>

"behave mswin        "set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
noremap  <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

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
set wildignore=*.bak,*.o,*.e,*~,*.swp
set t_Co=256
set ttyfast     " when will this cause problems?
autocmd GUIEnter * set vb t_vb=       "close beep
set noerrorbells
autocmd VimEnter * set shellredir=>

if LINUX()
    colorscheme desert
endif

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

"delete space, delete
nnoremap <leader>ds :%s/\s\+$//<CR>
nnoremap <leader>dm :%s/\r//g<CR>

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
if WINDOWS()
    let $PATH = g:config_dir . '\lib' . ';' . $PATH
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
set statusline=%F%m%r%w%=[%{&ff}]\ [%Y]\ [ASCII=\%03.3b,HEX=\%02.2B]\ [%04l,%04v]\ [%p%%,%L]
set showcmd
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
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

if WINDOWS()
    set tags=tags
else
    set tags=tags
endif
nmap <F3> <c-]>
nmap <F4> <C-o>
nmap <Leader>tn :tnext<CR>
nmap <Leader>tp :tprevious<CR>

nmap <silent> <Leader>cr :FcyGentags<CR>
nmap <silent> <F5> :FcyGentags<CR>
command! -nargs=0 FcyGentags call s:fcy_gen_tags("", "")
function! s:fcy_gen_tags(filename, dir)
    "let l:cmd = 'ctags -R --language-force=c++'
    let l:cmd = 'ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
    "let l:cmd = 'ctags -R'
    call vimproc#system_bg(l:cmd)
    call vimproc#system_bg('gtags')
    echon "gen tags done"
endfunction

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType autohotkey setl omnifunc=ahkcomplete#Complete

filetype plugin indent on
syntax on

" ============================================================================
" Plugin SETTINGS
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
if count(s:plugin_groups, 'vimproc')
    function! BuildVimproc(info)
      " info is a dictionary with 3 fields
      " - name:   name of the plugin
      " - status: 'installed', 'updated', or 'unchanged'
      " - force:  set on PlugInstall! or PlugUpdate!
      if a:info.status != 'unchanged' || a:info.force
        if WINDOWS()
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
    Plug  'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }
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
if count(s:plugin_groups, 'neocomplete')
    Plug  'Shougo/neocomplete.vim'
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
if count(s:plugin_groups, 'vim-airline')
    Plug  'vim-airline/vim-airline'
endif
if count(s:plugin_groups, 'nerdcommenter')
    Plug  'scrooloose/nerdcommenter', { 'on': '<plug>NERDCommenterInvert' }
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
if count(s:plugin_groups, 'minibufexpl.vim')
    Plug 'fholgado/minibufexpl.vim'
endif
call plug#end()
endif


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
endif
if count(s:plugin_groups, 'vim-airline')
    let g:airline#extensions#tabline#enabled = 1
    "let g:airline#extensions#tabline#left_sep = ' '
    "let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#show_buffers = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#fnamemod = ':p:.'
endif
if count(s:plugin_groups, 'unite')
    let g:unite_data_directory=g:config_dir . '/.cache/unite'
    let g:unite_enable_start_insert=0
    let g:unite_source_history_yank_enable = 1
    let g:unite_force_overwrite_statusline=1

    call unite#filters#matcher_default#use(['matcher_fuzzy'])

    if executable('ag')
        let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden',
        \ '--ignore','lib','--ignore','obj','--ignore','out',
        \'-g', '']
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git''' .
        \ '--ignore ''lib'''
        let g:unite_source_grep_recursive_opt = ''
    endif

    nmap <c-p> <leader>f
    nnoremap <leader>f :Unite -start-insert -auto-resize buffer file_rec/async<cr>
    nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files -start-insert file_rec/async:!<cr>
    nnoremap <leader>ug :Unite -auto-resize grep:.<CR>
    nnoremap <leader>uy :Unite -auto-resize history/yank<cr>
    nnoremap <leader>uf :Unite -auto-resize buffer file<cr>
    nnoremap <leader>b :Unite -auto-resize buffer<cr>
    nnoremap <leader>ul :<C-u>Unite -start-insert -auto-resize line<CR>
    nnoremap <leader>uo :<C-u>Unite -auto-resize outline<CR>

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
if count(s:plugin_groups, 'neocomplete')
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

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
    let g:multi_cursor_next_key='<S-n>'
    let g:multi_cursor_prev_key='<S-p>'
    let g:multi_cursor_skip_key='<S-x>'
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
    if WINDOWS()
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
    let g:ctrlsf_ackprg = 'ag'
    let g:ctrlsf_ignore_dir = ['tags', 'GTAGS', 'GPATH', 'GRTAGS', 'obj', 'out', 'lib*']
    nnoremap <Leader>sp :CtrlSF<CR>
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
    if WINDOWS()
        let g:clang_library_path = 'C:\LLVM\bin'
    elseif LINUX()
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
    let g:ctags_opts = '--language-force=c++'
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
if count(s:plugin_groups, 'minibufexpl.vim')
    map <Leader>bl :MBEToggle<cr>
    "map <C-Tab> :MBEbn<cr>
    "map <C-S-Tab> :MBEbp<cr>
endif
if count(s:plugin_groups, 'vim-markdown')
    let g:vim_markdown_folding_disabled = 1
endif
if count(s:plugin_groups, 'vim-fswitch')
    map <silent> <Leader>h <ESC>:FSHere<CR>
endif

