" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :

" global var {{{
let g:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:cache_dir = g:config_dir . '/.cache'
let g:etc_dir = g:config_dir . '/etc'
let g:file_plug = g:config_dir . '/plug.vim'
let g:file_vimrc = g:config_dir . '/vimrc'
let g:file_basic_config = g:config_dir . '/basic.vim'
let g:file_vimrc_local = $HOME .'/.vimrc.local'
let g:file_log = g:cache_dir . '/vim.log'
let g:root_markers = ['.root', '.git', '.svn']
let g:root_marker = ''
let g:mapleader = get(g:,'mapleader',' ')

if executable('pip3') ==# 0
  echohl WarningMsg
  echom 'You need install python3 && pip3!'
  echohl None
endif


execute 'source ' . g:config_dir . '/basic.vim'


" complete_engine: coc ycm nvimlsp  {{{
let g:complete_engine = get(g:, 'complete_engine', 'nvimlsp')
if g:complete_engine ==# 'nvimlsp'
  if g:is_nvim ==# 0
    let g:complete_engine = 'coc'
  endif
endif

if filereadable(g:file_plug)
  execute 'source ' . g:file_plug
endif

nnoremap <silent> <leader>evp :execute 'e '  . g:file_plug<CR>
nnoremap <silent> <leader>evz :execute 'e '  . g:etc_dir . '/zshrc'<CR>
"autocmd! bufwritepost _vimrc source $MYVIMRC

" cursor FIXME nvim will modify terminal cursorshape {{{
if g:is_nvim
  au VimEnter,VimResume * set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
  au VimLeave,VimSuspend * set guicursor=a:hor50-blinkon200
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

" gui {{{
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

" autoread {{{
set autoread
augroup checktime
  au!
  autocmd FocusGained,BufEnter        * silent! checktime
  autocmd CursorHold                  * silent! checktime
  autocmd CursorHoldI                 * silent! checktime
augroup END

" terminal
tnoremap <ESC> <c-\><c-n>
if g:is_nvim
  autocmd myau TermOpen * startinsert
  tnoremap <c-o>p <c-\><c-n>pi
else
  tnoremap <c-o>p <C-W>"+
endif

" set working directory to the current file
nnoremap <silent> <leader>cdt :tcd %:p:h<CR>:pwd<CR>
nnoremap <silent> <leader>cda :cd %:p:h<CR>:pwd<CR>

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

" update lsp {{{
function! UpdateLsp() abort
  if executable('npm')
    call mkdir($HOME . '/.npm', 'p')
    silent !cd ~/.npm; npm install pyright
    silent !cd ~/.npm; npm install vim-language-server
  endif
  GoGetTools
  if executable('rustup')
    silent !rustup update
    silent !rustup component add rust-analysis rust-src
  endif
endfunction

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

if g:is_nvim ==# 0
  if g:is_win && !g:is_gui && g:is_conemu
    "enable 256 colors in ConEmu on Win
    set term=xterm
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
  else
    if has('termguicolors')
      " :h xterm-true-color
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    else
      set t_Co=256
    endif
  endif
else
    set termguicolors
endif

if $TERM =~# '256color' && g:is_tmux && !g:is_nvim
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
elseif $TERM ==# 'linux'
  let g:colorscheme = 'desert'
  let g:background='dark'
  set t_Co=256
endif

exec 'colorscheme ' . g:colorscheme
exec 'set background=' . g:background
" }}}


if (HasPlug('LeaderF') != -1)
  autocmd myau Syntax * hi Lf_hl_cursorline guifg=fg
endif

" post load vimrc config {{{
if exists('*LoadAfter')
  call LoadAfter()
endif
if exists('*LoadAfterProject')
  call LoadAfterProject()
endif

filetype plugin indent on
syntax enable


" ============================================================================
" pvimrc {{{
" ============================================================================
" auto update pvimrc var
if (HasPlug('LeaderF') != -1)
  " init backup
  let g:b_Lf_MruFileExclude = deepcopy(g:Lf_MruFileExclude)
  let g:b_Lf_WildIgnore = deepcopy(g:Lf_WildIgnore)
  let g:b_Lf_RgConfig = deepcopy(g:Lf_RgConfig)
  let g:b_gencconf_ignore_dirs = deepcopy(g:gencconf_ignore_dirs)

  " update ignore from pvimrc
  function! s:update_ignore()
    " init var
    if !exists('g:custom_ignore')
      let g:custom_ignore = {}
    endif
    if !exists('g:custom_ignore["dir"]')
      let g:custom_ignore['dir'] = []
    endif
    if !exists('g:custom_ignore["file"]')
      let g:custom_ignore['file'] = []
    endif
    if !exists('g:custom_ignore["rg"]')
      let g:custom_ignore['rg'] = []
    endif

    let g:Lf_MruFileExclude = deepcopy(g:b_Lf_MruFileExclude)
    let g:Lf_WildIgnore = deepcopy(g:b_Lf_WildIgnore)
    let g:Lf_RgConfig = deepcopy(g:b_Lf_RgConfig)
    let g:gencconf_ignore_dirs = deepcopy(g:b_gencconf_ignore_dirs)
    for i in g:custom_ignore['file']
      call add(g:Lf_MruFileExclude, i)
      call add(g:Lf_WildIgnore['file'], i)
      call add(g:Lf_RgConfig, '--glob=!' . i)
    endfor
    for i in g:custom_ignore['dir']
      call add(g:Lf_WildIgnore['dir'], i)
      call add(g:Lf_RgConfig, '--glob=!' . i)
      call add(g:gencconf_ignore_dirs, i)
    endfor
    for i in g:custom_ignore['rg']
      call add(g:Lf_RgConfig, i)
    endfor

    let g:rg_ignore=''
    for i in g:Lf_RgConfig
      let g:rg_ignore = g:rg_ignore . i . ' '
    endfor
    let g:Lf_GtagsfilesCmd = {
          \ '.git': 'rg --no-messages --files ' . g:rg_ignore,
          \ '.hg': 'rg --no-messages --files ' . g:rg_ignore,
          \ 'default': 'rg --no-messages --files ' . g:rg_ignore
          \}
  endfunction
  au myau SourcePost .pvimrc call s:update_ignore()
  call s:update_ignore()
endif

