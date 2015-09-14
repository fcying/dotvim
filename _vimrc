" vundle
set nocompatible

let mapleader=","

filetype off " required!
set rtp+=D:/tools/Vim/bundle/Vundle.vim

"set rtp+=D:/tools/Vim/bundle/ycm
	let g:ycm_server_use_vim_stdout = 1
	"let g:ycm_server_log_level = 'debug'
	let g:ycm_global_ycm_extra_conf = 'd:/tools/Vim/.ycm_extra_conf.py'   "配置默认的ycm_extra_conf.py
	nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>   "按<leader>jd 会跳转到定义
	let g:ycm_confirm_extra_conf=0    									  "打开vim时不再询问是否加载ycm_extra_conf.py配置
	let g:ycm_collect_identifiers_from_tag_files = 1 					  "使用ctags生成的tags文件	
	let g:ycm_cache_omnifunc=0											  " 禁止缓存匹配项,每次都重新生成匹配项
	let g:ycm_seed_identifiers_with_syntax=1							  " 语法关键字补全
	"在注释输入中也能补全
	let g:ycm_complete_in_comments = 1
	"在字符串输入中也能补全
	let g:ycm_complete_in_strings = 1
	"注释和字符串中的文字也会被收入补全
	let g:ycm_collect_identifiers_from_comments_and_strings = 0

call vundle#begin('D:/tools/Vim/bundle/')

Plugin 'jonathanfilip/vim-lucius'
	let g:lucius_style = 'light'

Plugin 'VundleVim/Vundle.vim'
Plugin 'Mizuchi/STL-Syntax'
"Plugin 'fholgado/minibufexpl.vim'
Plugin 'moll/vim-bbye'

Plugin 'Raimondi/delimitMate'
	let delimitMate_autoclose = 1
	let delimitMate_expand_cr = 1
	
"Plugin 'SirVer/ultisnips'

Plugin 'kien/ctrlp.vim'

Plugin 'kshenoy/vim-signature'

Plugin 'majutsushi/tagbar'
    let g:tagbar_ctags_bin = 'D:/tools/ctags/ctags.exe'
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
    let g:clang_library_path="D:/tools/Vim"
    let g:clang_auto_select=1

Plugin 'a.vim'
    map <leader>h <ESC>:A<CR>
	map <leader>sh <ESC>:AS<CR>

Plugin 'bling/vim-airline'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#left_sep = ' '
	let g:airline#extensions#tabline#left_alt_sep = '|'

Plugin 'scrooloose/nerdtree'
    nmap <leader>nt :NERDTree<cr>
	let NERDTreeWinSize=32
	let NERDTreeWinPos="right"
	let NERDTreeShowHidden=1
	let NERDTreeMinimalUI=1
	let NERDTreeAutoDeleteBuffer=1
	let NERDTreeShowBookmarks=1
    let NERDTreeShowLineNumbers=1

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
filetype plugin indent on    " required
syntax on

"colorscheme lucius


" windows like
behave mswin		"set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
vnoremap <C-X> 		"+x
vnoremap <C-C>      "+y
map		 <C-V>      "+gP
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

set wildmenu
set guioptions -=T
set guioptions -=m
set guifont=Consolas:h11
set mouse=a
set backspace=indent,eol,start whichwrap+=<,>,[,]
autocmd GUIEnter * set vb t_vb=       " 关闭警告提示
" when will this cause problems?
set ttyfast
" 不要包含标准错误，但是允许 Vim 初始化其默认值
autocmd VimEnter * set shellredir=>
"将-连接符也设置为单词
set isk+=-

"set columns=135           "初始窗口的宽度
"set lines=50              "初始窗口的高度
"winpos 620 45             "初始窗口的位置
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

set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set scrolloff=3
set fenc=utf-8
set autoindent
set hidden
set noswapfile
set nobackup
set nowritebackup
"set encoding=utf-8

set incsearch
set hlsearch
set ignorecase
set smartcase
"set autochdir

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set number  
set ruler
set nowrap
set laststatus=2
"set cursorline
"set cursorcolumn
autocmd! bufwritepost _vimrc source % 

set foldmethod=syntax
set nofoldenable

nnoremap <leader>ee :e $VIM/_vimrc<CR>

" 自动补全配置
set completeopt=longest,menu	"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
autocmd InsertLeave * if pumvisible() == 0|pclose|endif	"离开插入模式后自动关闭预览窗口
imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"
"上下左右TAB键的行为 会显示其他信息
inoremap <expr> <TAB>  	   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB>    pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

