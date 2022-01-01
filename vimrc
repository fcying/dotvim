" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :

" global var {{{
let g:root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:config_dir = g:root_dir
let g:etc_dir = g:root_dir . '/etc'

execute 'source ' . g:root_dir . '/basic.vim'
execute 'source ' . g:root_dir . '/plug.vim'
" plugin list {{{
MyPlug 'lambdalisue/suda.vim', {'cmd':['SudaRead', 'SudaWrite']}
MyPlug 'simnalamburt/vim-mundo'
MyPlug 'chrisbra/Colorizer'
"MyPlug 'skywind3000/vim-quickui'
"MyPlug 'liuchengxu/vim-which-key'
"MyPlug 'tpope/vim-apathy'
"MyPlug 'roxma/vim-paste-easy'

MyPlug 'MattesGroeger/vim-bookmarks'
MyPlug 'derekwyatt/vim-fswitch'
MyPlug 'Yggdroot/indentLine', {'cmd': 'IndentLinesToggle'}

call MyPlugUpgrade()

" cursor FIXME nvim will modify terminal cursorshape {{{
if g:is_nvim
  au VimEnter,VimResume * set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
  au VimLeave,VimSuspend * set guicursor=a:hor50-blinkon200
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

" }}}


" ============================================================================
" color {{{
" ============================================================================
let g:colorscheme = get(g:, 'colorscheme', 'solarized8')

call ColorConfig()

call LoadAfterConfig()

