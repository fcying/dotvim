" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :

" init var {{{
let g:file_vimrc_local = $HOME .'/.vimrc.local'
let g:cache_dir = g:root_dir . '/.cache'
let g:file_log = g:cache_dir . '/vim.log'
let g:ctags_opt = '--options=' . g:root_dir . '/etc/ctags'

let g:is_win = has('win32')
let g:is_nvim = has('nvim')
let g:is_gui = has('gui_running') || !empty($NVIM_GUI)
let g:is_tmux = exists('$TMUX')
let g:is_conemu = !empty($CONEMUBUILD)
let g:is_wsl = isdirectory('/mnt/c')

let g:has_go = executable('go')
let g:has_rg = executable('rg')
let g:use_leaderf = get(g:,'use_leaderf','0')
let g:lsp_ignore = get(g:,'lsp_ignore',[''])

let g:mapleader = get(g:,'mapleader',' ')
let g:root_markers = ['.root', '.git', '.repo', '.svn']
let g:root_marker = ''
let g:force_update = get(g:,'force_update','0')

if !g:is_nvim
  set nocompatible
  let g:use_leaderf = 1
end

let g:ignore_default = {
      \ 'dir':['.root','.svn','.git','.repo','.ccls-cache','.cache','.ccache'],
      \ 'file':['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]',
      \ 'GTAGS', 'GRTAGS', 'GPATH', 'prj_tag','tag'],
      \ 'mru':['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll'],
      \ 'rg':['--max-columns=300', '--iglob=!obj', '--iglob=!out']}
let g:ignore = {'dir':[], 'file':[], 'rg':[], 'mru':[]}

exec 'set rtp+=' . g:root_dir

if !isdirectory(g:cache_dir)
  call mkdir(g:cache_dir)
endif

augroup myau
  autocmd!
augroup END

" find project root dir {{{
function! GetRootDir()
  for l:item in g:root_markers
    let l:dir = finddir(l:item, '.;')
    if !empty(l:dir)
      break
    endif
  endfor
  if !empty(l:dir)
    let g:root_marker = fnamemodify(l:dir, ':p:h')
  else
    let g:root_marker = getcwd()
  endif
endfunction
call GetRootDir()


" find user config && project config  {{{
if filereadable(g:file_vimrc_local)
  execute 'source ' . g:file_vimrc_local
endif

let g:pvimrc_path = findfile('.pvimrc', g:root_marker . ';' . g:root_marker . '..')
if g:pvimrc_path !=# ''
  "exec 'sandbox source ' . g:pvimrc_path
  exec 'source ' . g:pvimrc_path
else
  let g:pvimrc_path = g:root_marker . '/.pvimrc'
endif

nnoremap <silent> <leader>evc :execute 'e '  . g:root_dir<CR>
nnoremap <silent> <leader>evl :execute 'e '  . g:file_vimrc_local<CR>

" }}}


" ============================================================================
" basic settings
" ============================================================================
" disable beep  {{{
set t_vb=
set visualbell
set noerrorbells

" encoding {{{
let $LANG='en' "zh-cn some plugin(ex: gina) work error
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,euc-kr,latin1
scriptencoding utf-8
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim
if g:is_win
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif

" basic {{{
set mouse=nv
set clipboard+=unnamedplus
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
set formatoptions+=mM
autocmd BufEnter * setl formatoptions-=o   "stop auto insert comment, FileType can't work
set virtualedit=onemore        "onemore all
set history=2000
set scrolloff=3
set hidden
set noautochdir
set updatetime=300
if g:is_win
  let $PATH = g:root_dir . '\vendor' . ';' . $PATH
else
  let $PATH = g:root_dir . '/vendor' . ':' . $PATH
endif

" backup {{{
set nobackup
set nowritebackup
set undofile
if g:is_nvim
  execute 'set undodir=' . g:cache_dir . '/undodir-nvim'
else
  execute 'set undodir=' . g:cache_dir . '/undodir'
endif
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

" tab shift {{{
set expandtab        "retab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" quickfix locationlist {{{
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
nnoremap <silent> <leader>lo :lopen<CR>
nnoremap <silent> <leader>lc :lclose<CR>
nnoremap <silent> <leader>ln :lnext<CR>
nnoremap <silent> <leader>lp :lprevious<CR>
autocmd myau FileType qf noremap <silent><buffer> q :q<CR>

" filetype {{{
autocmd myau FileType go setlocal noexpandtab nolist
autocmd myau FileType vim,json,jsonc,yaml,toml,dosbatch
      \ setlocal shiftwidth=2
      \ softtabstop=2
      \ tabstop=2
      \ expandtab
autocmd myau BufNewFile,BufRead *.conf setl filetype=conf
autocmd myau BufNewFile,BufRead *.json setl filetype=jsonc
autocmd myau BufNewFile,BufRead .tasks setl filetype=conf
autocmd myau BufNewFile,BufRead syslog setl filetype=messages

if g:is_nvim
  " use filetype.lua instead of filetype.vim {{{
  let g:do_filetype_lua = 1
  let g:did_load_filetypes = 0

  " force write shada on leaving nvim {{{
  autocmd myau VimLeave * wshada!

  set inccommand=nosplit
endif

" foldmethod {{{
set foldmethod=manual
set nofoldenable

" diff opt {{{
if has('patch-8.1.0360') || g:is_nvim
  set diffopt+=internal,algorithm:patience
endif

" tmux {{{
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

" restore-cursor to the last position {{{
" add only line(".") == 1 jump
augroup vimStartup
  au!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && line(".") == 1 && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
augroup END

" autoread {{{
set autoread
augroup checktime
  au!
  autocmd FocusGained,BufEnter        * silent! checktime
  autocmd CursorHold                  * silent! checktime
  autocmd CursorHoldI                 * silent! checktime
augroup END

" terminal {{{
tnoremap <ESC> <c-\><c-n>
if g:is_nvim
  autocmd myau TermOpen * startinsert
  tnoremap <c-o>p <c-\><c-n>pi
else
  tnoremap <c-o>p <C-W>"+
endif

" set working directory to the current file {{{
nnoremap <silent> <leader>cdt :tcd %:p:h<CR>:pwd<CR>
nnoremap <silent> <leader>cda :cd %:p:h<CR>:pwd<CR>

" ignore file in search && complete {{{
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


" ============================================================================
" keymap
" ============================================================================
nnoremap <F2> :set number! number?<CR>
nnoremap <F3> :set list! list?<CR>
nnoremap <F4> :set wrap! wrap?<CR>
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

set pastetoggle=<F5>
set pastetoggle=<leader>z
" disbale paste mode when leaving insert mode
autocmd myau InsertLeave * set nopaste

" make Telescope <esc> actions.close slow
" Automatically set paste mode in Vim when pasting in insert mode
"function! XTermPasteBegin()
"  set pastetoggle=<Esc>[201~
"  set paste
"  return ''
"endfunction
"inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" fast save ctrl-s {{{
nnoremap <C-s> :update<CR>
vnoremap <C-s> :<C-u>update<CR>
cnoremap <C-s> <C-u>update<CR>
inoremap <C-s> <C-o>:update<CR>

" save with sudo;  use vim-eunuch instead {{{
"nnoremap <leader>ws :w !sudo tee %<CR>

" Wrapped lines goes down/up to next row, rather than next line in file
"nnoremap k gk
"nnoremap gk k
"nnoremap j gj
"nnoremap gj j

" fast ident {{{
xnoremap < <gv
xnoremap > >gv|
nnoremap > >>_
nnoremap < <<_

" remap q Q {{{
nnoremap gQ Q
nnoremap Q q
nnoremap q <nop>

" insert mode emacs {{{
inoremap <c-a> <home>
inoremap <c-e> <end>

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

" cmd history search {{{
cnoremap <expr> <c-n> pumvisible() ? "<c-n>" : "<down>"
cnoremap <expr> <c-p> pumvisible() ? "<c-p>" : "<up>"

" tab {{{
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

" Start new line {{{
inoremap <S-Return> <C-o>o

" delete space, ^M, ansi escape codes {{{
nnoremap <leader>ds :%s/\s\+$//g<CR>:noh<CR>
nnoremap <leader>dm :%s/\r$//g<CR>:noh<CR>
nnoremap <leader>da :%s/\%x1b\[[0-9;]*m//g<CR>:noh<CR>

" paste without overwrite register {{{
xnoremap p "_dP

" get visual selection && virtual mode search {{{
" https://github.com/idanarye/vim-vebugger/blob/master/autoload/vebugger/util.vim
func! GetVisualSelection() abort
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: col2 - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    "echom join(lines, "\n")
    return join(lines, "\n")
endf
xnoremap * :<C-u>let @/ = GetVisualSelection()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>let @/ = GetVisualSelection()<CR>?<C-R>=@/<CR><CR>

" completion {{{
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
" close menu and start a new line
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>": "\<cr>"
set completeopt=menuone,noselect,noinsert
set shortmess+=c
if has('patch-8.1.1902')
  set completeopt+=popup
  set completepopup=border:off
endif


" ============================================================================
" function
" ============================================================================
" large file {{{
let g:LargeFile = 1024 * 1024 * 10
autocmd myau BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
function! LargeFile()
  set binary
  " no syntax highlighting etc
  "set eventignore+=FileType
  " display message
  autocmd myau VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction


" auto pairs {{{
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


" tags ltag {{{
set tags=tags,tags;
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-

func! Removetags()
  ClearClangConf
  ClearCtags
endf

func! Gentags()
  ClearClangConf
  GenClangConf
  GenCtags
  if exists(':LspRestart')
    LspRestart
  endif
endf
nnoremap <silent> tg :call Gentags()<CR>
nnoremap <silent> tc :call Removetags()<CR>


" wsl clip {{{
if g:is_wsl
  let s:clip = '/mnt/c/Windows/System32/clip.exe'
  if executable(s:clip)
    augroup WSLYank
      autocmd!
      autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
  endif
endif


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

" dictionary {{{
" nvim set dict in cmp_dictionary setup
if !g:is_nvim
  execute 'set dictionary+=' . g:root_dir . '/dict/dictionary'
  function! s:add_dict()
    let l:dict = g:root_dir . '/dict/' . &filetype . '.dict'
    if filereadable(expand(l:dict))
      execute 'setlocal dictionary+=' . l:dict
    endif
  endfunction
  autocmd myau FileType * :call s:add_dict()
endif


function! PostLoadConfig()
  if exists('*PostLoad')
    call PostLoad()
  endif
  if exists('*PostLoadProject')
    call PostLoadProject()
  endif
  filetype plugin indent on
  syntax enable
endfunction

function! ColorConfig()
  if !exists('g:colorscheme')
    let g:colorscheme = 'solarized8'
  endif
  set termguicolors
  if g:colorscheme == 'solarized8'
    let g:background = get(g:,'background','light')
  elseif g:colorscheme == 'default'
    let g:background = get(g:,'background','dark')
  else
    let g:colorscheme = get(g:,'colorscheme','molokai')
    let g:background = get(g:,'background','dark')
  endif

  if $TERM ==# 'linux'
    let g:colorscheme = 'desert'
    let g:background='dark'
    set t_Co=256
    set notgc
  endif

  if !g:is_nvim
    " :h xterm-true-color
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif

  exec 'colorscheme ' . g:colorscheme
  exec 'set background=' . g:background

  if (HasPlug('LeaderF') != -1)
    autocmd myau Syntax * hi Lf_hl_cursorline guifg=fg
  endif
endfunction


" ============================================================================
" auto update pvimrc var {{{
" ============================================================================
function! UpdateIgnore()
  " init ignore config
  let g:ignore_full = {}
  let g:ignore_full.dir = g:ignore_default.dir + g:ignore.dir
  let g:ignore_full.file = g:ignore_default.file + g:ignore.file
  let g:ignore_full.rg = g:ignore_default.rg + g:ignore.rg
  let g:ignore_full.mru = g:ignore_default.mru + g:ignore.mru

  " update rg config
  for i in g:ignore_full.file
    call add(g:ignore_full.rg, '-g=!' . i)
  endfor
  for i in g:ignore_full.dir
    call add(g:ignore_full.rg, '-g=!' . i)
  endfor

  " leaderf
  let g:Lf_WildIgnore = {}
  let g:Lf_MruFileExclude = g:ignore_full.mru
  let g:Lf_WildIgnore.dir = g:ignore_full.dir
  let g:Lf_WildIgnore.file = g:ignore_full.file
  let g:Lf_RgConfig = g:ignore_full.rg

  " gen_clang_conf.vim
  let g:gencconf_ignore_dir = g:ignore_full.dir

  if (HasPlug('telescope.nvim') != -1) "{{{
    lua require('config').telescope_update_ignore()
  endif
endfunction
execute 'autocmd myau BufWritePost .pvimrc nested source ' . g:pvimrc_path
au myau SourcePost .pvimrc call UpdateIgnore()
nnoremap <silent> <leader>ep  :execute 'e '  . g:pvimrc_path<CR>

" call in MyPlugUpgrade()
"call UpdateIgnore()
