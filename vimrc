" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :

" global var {{{
let g:root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:config_dir = g:root_dir
let g:etc_dir = g:root_dir . '/etc'
let g:lsp_servers = ['vimls', 'bashls', 'dockerls',
      \ 'sumneko_lua', 'gopls', 'pylsp', 'rust_analyzer']
call add(g:lsp_servers, 'clangd')
"call add(g:lsp_servers, 'ccls')

execute 'source ' . g:root_dir . '/basic.vim'

" complete_engine: coc nvimlsp  {{{
let g:complete_engine = get(g:, 'complete_engine', 'nvimlsp')
if g:complete_engine ==# 'nvimlsp'
  if g:is_nvim ==# 0
    let g:complete_engine = 'coc'
  endif
endif

execute 'source ' . g:root_dir . '/plug.vim'
" plugin list {{{
MyPlug 'lambdalisue/suda.vim', {'cmd':['SudaRead', 'SudaWrite']}
MyPlug 'simnalamburt/vim-mundo'
MyPlug 'chrisbra/Colorizer'
"MyPlug 'skywind3000/vim-quickui'
"MyPlug 'liuchengxu/vim-which-key'
"MyPlug 'tpope/vim-apathy'
"MyPlug 'roxma/vim-paste-easy'

if g:is_nvim
  "MyPlug 'nathom/filetype.nvim'
  " FIXME nvim cursorhold bug https://github.com/neovim/neovim/issues/12587
  MyPlug 'antoinemadec/FixCursorHold.nvim'
  " FIXME https://github.com/neovim/neovim/issues/14967 in 0.5.0
  "MyPlug 'kevinhwang91/nvim-hclipboard'
else
  MyPlug 'xolox/vim-misc'
  "MyPlug 'xolox/vim-session'
  MyPlug 'tmux-plugins/vim-tmux-focus-events'
  MyPlug 'roxma/vim-tmux-clipboard'
endif

MyPlug 'MattesGroeger/vim-bookmarks'
MyPlug 'derekwyatt/vim-fswitch'
MyPlug 'Yggdroot/indentLine', {'cmd': 'IndentLinesToggle'}

"MyPlug 'skywind3000/vim-preview'
MyPlug 'skywind3000/asyncrun.vim', {'cmd': ['AsyncRun', 'AsyncStop'] }
MyPlug 'skywind3000/asynctasks.vim', {'cmd': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }

MyPlug 't9md/vim-choosewin', {'keys':'<Plug>(choosewin)'}
MyPlug 'preservim/tagbar', {'cmd':'TagbarToggle'}

MyPlug 'godlygeek/tabular', {'ft':'markdown'}
MyPlug 'plasticboy/vim-markdown', {'ft':'markdown'}

call MyPlugUpgrade()

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
    silent !go install -v golang.org/x/tools/cmd/goimports@latest
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

" }}}



" ============================================================================
" color {{{
" ============================================================================
" solarized8 gruvbox molokai
let g:colorscheme = get(g:, 'colorscheme', 'solarized8')
let g:background=get(g:, 'background', 'light')

call ColorConfig()

if (HasPlug('LeaderF') != -1)
  autocmd myau Syntax * hi Lf_hl_cursorline guifg=fg
endif

call LoadAfterConfig()

