" deoplete ncm2 asyncomplete neocomplete ycm completor coc
if g:is_vim8
  let g:complete_func = get(g:, 'complete_func', 'ncm2')
else
  let g:complete_func = get(g:, 'complete_func', 'neocomplete')
endif

" ============================================================================
" plug func {{{
" ============================================================================
function! s:load_plugins() abort
  for l:plugin in g:plug_list
    "echo l:plugin
    exec l:plugin
  endfor
endfunction

function! s:os_do(linux, windows) abort
  if g:is_win
    return a:windows . "'}"
  else
    return a:linux . "'}"
  endif
endfunction

function! InstallDeoplete(info) abort
  if a:info.status !=# 'unchanged' || a:info.force
    silent !echo "InstallDeoplete"
    if g:is_nvim
      silent UpdateRemotePlugins
    else
      silent !pip3 install neovim --upgrade
    endif
  endif
endfunction

function! BuildGoCode(info) abort
  if a:info.status !=# 'unchanged' || a:info.force
    if g:is_win
      let l:cmd = 'cp -R ' . g:config_dir . '\plugged\gocode\vim\ftplugin '
            \ . $HOME . '\vimfiles'
      call system(l:cmd)
      let l:cmd = 'cp -R ' . g:config_dir . '\plugged\gocode\vim\autoload ' . $HOME
            \ . '\vimfiles'
      call system(l:cmd)
    else
      let l:cmd = 'sh ' . g:config_dir . '/plugged/gocode/vim/update.sh'
      call system(l:cmd)
    endif
  endif
endfunction
"}}}


" ============================================================================
" plugin {{{
" ============================================================================
let g:plug_list = []
call add(g:plug_list, "Plug 'junegunn/vim-plug'")
call add(g:plug_list, "Plug 'mbbill/fencview'")
call add(g:plug_list, "Plug 'adah1972/tellenc'")
"call add(g:plug_list, "Plug 'sheerun/vim-polyglot'")   "A solid language pack for Vim.
call add(g:plug_list, "Plug 'bogado/file-line'")
call add(g:plug_list, "Plug 'tpope/vim-eunuch'")
call add(g:plug_list, "Plug 'itchyny/lightline.vim'")
call add(g:plug_list, "Plug 'cespare/vim-toml'")
call add(g:plug_list, "Plug 'moll/vim-bbye', {'on':'Bdelete'}")
call add(g:plug_list, "Plug 'MattesGroeger/vim-bookmarks'")
call add(g:plug_list, "Plug 'thinca/vim-ref'")
call add(g:plug_list, "Plug 'tpope/vim-surround'")
call add(g:plug_list, "Plug 'terryma/vim-expand-region'")
call add(g:plug_list, "Plug 'mg979/vim-visual-multi', {'branch': 'test'}")
call add(g:plug_list, "Plug 'derekwyatt/vim-fswitch'")
call add(g:plug_list, "Plug 'nathanaelkane/vim-indent-guides', {'on':'<Plug>IndentGuidesToggle'}")
call add(g:plug_list, "Plug 'scrooloose/nerdtree', {'on':['NERDTreeToggle', 'NERDTreeFind']}")
call add(g:plug_list, "Plug 'scrooloose/nerdcommenter'")
call add(g:plug_list, "Plug 'majutsushi/tagbar', {'on':'TagbarToggle'}")
call add(g:plug_list, "Plug 'xolox/vim-session'")
call add(g:plug_list, "Plug 'xolox/vim-misc'")
call add(g:plug_list, "Plug 'Vimjas/vim-python-pep8-indent', {'for':'python'}")
call add(g:plug_list, "Plug 'wsdjeg/vim-autohotkey', {'for':'autohotkey'}")
call add(g:plug_list, "Plug 'godlygeek/tabular', {'for':'markdown'}")
call add(g:plug_list, "Plug 'plasticboy/vim-markdown', {'for':'markdown'}")
call add(g:plug_list, "Plug 't9md/vim-choosewin', {'on':'<Plug>(choosewin)'}")
"call add(g:plug_list, "Plug 'Raimondi/delimitMate'")
call add(g:plug_list, "Plug 'dyng/ctrlsf.vim'")
call add(g:plug_list, "Plug 'easymotion/vim-easymotion'")
call add(g:plug_list, "Plug 'lambdalisue/gina.vim', {'on': 'Gina'}")
"call add(g:plug_list, "Plug 'tpope/vim-fugitive'")
call add(g:plug_list, "Plug 'Yggdroot/LeaderF', {'do': '" . s:os_do('./install.sh','.\install.bat'))

"call add(g:plug_list, "Plug 'ludovicchabant/vim-gutentags'")
"call add(g:plug_list, "Plug 'skywind3000/gutentags_plus'")
call add(g:plug_list, "Plug 'skywind3000/vim-preview'")
call add(g:plug_list, "Plug 'skywind3000/asyncrun.vim'")
call add(g:plug_list, "Plug 'jsfaint/gen_tags.vim'")
call add(g:plug_list, "Plug 'fcying/gen_clang_conf.vim'")

if g:complete_func ==# 'deoplete'
  call add(g:plug_list, "Plug 'Shougo/deoplete.nvim', {'do': function('InstallDeoplete')}")
  if g:is_nvim ==# 0
    call add(g:plug_list, "Plug 'roxma/nvim-yarp'")
    call add(g:plug_list, "Plug 'roxma/vim-hug-neovim-rpc'")
  endif
  "call add(g:plug_list, "Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do':'" . 
  "      \ s:os_do('bash install.sh', 
  "      \ 'powershell -executionpolicy bypass -File install.ps1'))
  call add(g:plug_list, "Plug 'Shougo/neco-syntax'")
  call add(g:plug_list, "Plug 'Shougo/neoinclude.vim'")
  call add(g:plug_list, "Plug 'Shougo/neco-vim'")
  call add(g:plug_list, "Plug 'Shougo/deoplete-clangx'")
  call add(g:plug_list, "Plug 'zchee/deoplete-jedi'")
  " for goto feature
  call add(g:plug_list, "Plug 'davidhalter/jedi-vim'")
  if g:has_go
    call add(g:plug_list, "Plug 'zchee/deoplete-go', {'do':'" . s:os_do('make','mingw32-make'))
  endif
  call add(g:plug_list, "Plug 'Shougo/neosnippet.vim'")
  call add(g:plug_list, "Plug 'Shougo/neosnippet-snippets'")
elseif g:complete_func ==# 'ncm2'
  if g:is_nvim ==# 0
    call add(g:plug_list, "Plug 'roxma/vim-hug-neovim-rpc'")
  endif
  call add(g:plug_list, "Plug 'roxma/nvim-yarp'")
  call add(g:plug_list, "Plug 'ncm2/ncm2', {'do': 'pip3 install neovim jedi --upgrade'}")
  if g:is_win ==# 0
    call add(g:plug_list, "Plug 'ncm2/ncm2-tmux'")
  endif
  call add(g:plug_list, "Plug 'ncm2/ncm2-bufword'")
  call add(g:plug_list, "Plug 'ncm2/ncm2-path'")
  call add(g:plug_list, "Plug 'ncm2/ncm2-pyclang'")
  call add(g:plug_list, "Plug 'ncm2/ncm2-jedi'")
  "curl https://sh.rustup.rs -sSf | sh
  "rustup toolchain add nightly && cargo +nightly install racer && rustup component add rust-src
  call add(g:plug_list, "Plug 'ncm2/ncm2-racer'")
  "call add(g:plug_list, "Plug 'ncm2/ncm2-go'")
  call add(g:plug_list, "Plug 'prabirshrestha/async.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/vim-lsp'")
  call add(g:plug_list, "Plug 'ncm2/ncm2-vim-lsp'")
  call add(g:plug_list, "Plug 'jsfaint/ncm2-vim'")
  call add(g:plug_list, "Plug 'Shougo/neco-vim'")
  call add(g:plug_list, "Plug 'jsfaint/ncm2-syntax'")
  call add(g:plug_list, "Plug 'Shougo/neco-syntax'")
elseif g:complete_func ==# 'coc'
  call add(g:plug_list, "Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}")
  call add(g:plug_list, "Plug 'neoclide/jsonc.vim'")
elseif g:complete_func ==# 'neocomplete'
  if has('lua')
    call add(g:plug_list, "Plug 'Shougo/neocomplete'")
    call add(g:plug_list, "Plug 'davidhalter/jedi-vim', {'for':'python'}")
    call add(g:plug_list, "Plug 'Shougo/neoinclude.vim'")
    call add(g:plug_list, "Plug 'Shougo/neco-syntax'")
    call add(g:plug_list, "Plug 'Shougo/neco-vim', {'for':'vim'}")
    call add(g:plug_list, "Plug 'nsf/gocode', {'do':function('BuildGoCode'), 'for':'go'}")
    call add(g:plug_list, "Plug 'dgryski/vim-godef', {'for':'go'}")
  endif
elseif g:complete_func ==# 'asyncomplete'
  call add(g:plug_list, "Plug 'prabirshrestha/async.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/asyncomplete.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/vim-lsp'")
  call add(g:plug_list, "Plug 'prabirshrestha/asyncomplete-lsp.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/asyncomplete-tags.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/asyncomplete-buffer.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/asyncomplete-file.vim'")
  call add(g:plug_list, "Plug 'yami-beta/asyncomplete-omni.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/asyncomplete-necosyntax.vim'")
  call add(g:plug_list, "Plug 'prabirshrestha/asyncomplete-necovim.vim'")
elseif g:complete_func ==# 'completor'
  call add(g:plug_list, "Plug 'maralla/completor.vim'")
elseif g:complete_func ==# 'ycm'
  call add(g:plug_list, "Plug 'Valloric/YouCompleteMe'")
endif

"color
"call add(g:plug_list, "Plug 'altercation/vim-colors-solarized'")
call add(g:plug_list, "Plug 'fcying/vim-colors-solarized'")
call add(g:plug_list, "Plug 'tomasr/molokai'")
call add(g:plug_list, "Plug 'icymind/NeoSolarized'")
"}}}


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
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>



" auto install
let g:plug_auto_install = get(g:, 'plug_auto_install', 0)
if g:plug_auto_install == 1 || exists('s:first_install')
  let s:plug_list_cache=g:config_dir . '/.cache/plug_list_cache'
  if !isdirectory(g:config_dir . '/.cache')
    call mkdir(g:config_dir . '/.cache')
  endif
  if filereadable(s:plug_list_cache)
    let s:last_plug_list=readfile(s:plug_list_cache, 'b')
  else
    let s:last_plug_list=[]
    echom 'no plug_list_cache'
  endif
  let s:plug_string=[string(g:plug_list)]
  if s:last_plug_list != s:plug_string
    call writefile(s:plug_string, s:plug_list_cache, 'b')
    echom 'update plug_list_cache'
    silent PlugInstall
  endif
endif



" ============================================================================
" plugin settings {{{
" ============================================================================
let s:plug_list_string = string(g:plug_list)

function! FindPlug(plugname) abort
  return stridx(s:plug_list_string, a:plugname)
endfunction


if (FindPlug('vim-indent-guides') != -1)
  let g:indent_guides_enable_on_vim_startup=0
  let g:indent_guides_start_level=2
  let g:indent_guides_guide_size=1
  :nmap <silent> <Leader>i <Plug>IndentGuidesToggle
endif

if (FindPlug('gen_tags.vim') != -1)
  nnoremap <silent> <leader>tg :GenCtags<CR>:GenGTAGS<CR>:GenClangConf<CR>
  nnoremap <silent> <leader>tc :ClearGTAGS!<CR>:echo "clear tags end"<CR>
  nnoremap <silent> <leader>te :EditExt<CR>

  autocmd fcying_au User GenTags#CtagsLoaded let g:gen_tags#ctags_auto_gen = 1
  autocmd fcying_au User GenTags#GtagsLoaded let g:gen_tags#gtags_auto_gen = 1

  let g:gen_tags#use_cache_dir = 0
  let g:gen_tags#ctags_auto_gen = 0
  let g:gen_tags#gtags_auto_gen = 0
  let g:gen_tags#gtags_default_map = 0
  let g:gen_tags#blacklist = ['$HOME']
  let g:gen_tags#statusline = 1

  if g:is_vim8
    set cscopequickfix=s+,c+,d+,i+,t+,e+,a+
  else
    set cscopequickfix=s+,c+,d+,i+,t+,e+
  endif

  function! s:gen_tags_find(cmd, keyword) abort
    let l:cmd = 'cs find ' . a:cmd . ' ' . a:keyword
    silent exec 'cexpr l:cmd'
    call setqflist([], 'a')
    silent exec l:cmd
    belowright copen
  endfunction

  "c    Find functions calling this function
  "d    Find functions called by this function
  "e    Find this egrep pattern
  "f    Find this file
  "g    Find this definition
  "i    Find files #including this file
  "s    Find this C symbol
  "t    Find this text string
  noremap  <leader>cc :call <SID>gen_tags_find('c', "<C-R><C-W>")<CR>
  noremap  <leader>cd :call <SID>gen_tags_find('d', "<C-R><C-W>")<CR>
  noremap  <leader>ce :call <SID>gen_tags_find('e', "<C-R><C-W>")<CR>
  noremap  <leader>cf :call <SID>gen_tags_find('f', "<C-R><C-F>")<CR>
  noremap  <leader>cg :call <SID>gen_tags_find('g', "<C-R><C-W>")<CR>
  noremap  <leader>ci :call <SID>gen_tags_find('i', "<C-R><C-F>")<CR>
  noremap  <leader>cs :call <SID>gen_tags_find('s', "<C-R><C-W>")<CR>
  noremap  <leader>ct :call <SID>gen_tags_find('t', "<C-R><C-W>")<CR>

  autocmd fcying_au FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  autocmd fcying_au FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
endif

if (FindPlug('gutentags_plus') != -1)
  nnoremap <leader>tg :GutentagsUpdate<CR>
  " enable gtags module
  let g:gutentags_modules = ['ctags', 'gtags_cscope']
  " config project root markers.
  let g:gutentags_project_root = ['.root']
  " generate datebases in my cache directory, prevent gtags files polluting my project
  let g:gutentags_cache_dir = expand($HOME . '/.cache/tags')
  " forbid gutentags adding gtags databases
  let g:gutentags_auto_add_gtags_cscope = 0
  let g:gutentags_plus_nomap = 1
  noremap <silent> <leader>cs :GscopeFind s <C-R><C-W><cr>
  noremap <silent> <leader>cg :GscopeFind g <C-R><C-W><cr>
  noremap <silent> <leader>cc :GscopeFind c <C-R><C-W><cr>
  noremap <silent> <leader>ct :GscopeFind t <C-R><C-W><cr>
  noremap <silent> <leader>ce :GscopeFind e <C-R><C-W><cr>
  noremap <silent> <leader>cf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
  noremap <silent> <leader>ci :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
  noremap <silent> <leader>cd :GscopeFind d <C-R><C-W><cr>
  noremap <silent> <leader>ca :GscopeFind a <C-R><C-W><cr>
  autocmd fcying_au FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  autocmd fcying_au FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>

  let g:gutentags_generate_on_missing = 0
  let g:gutentags_generate_on_new = 0
  let g:gutentags_generate_on_write = 0
endif

if (FindPlug('asyncrun') != -1)
  let g:asyncrun_silent = 0
  autocmd User AsyncRunStop :echo "AsyncRunStop"
endif

if (FindPlug('lightline') != -1)
  set showtabline=1
  "let g:lightline = {'colorscheme': 'default'}
  let g:lightline = {'colorscheme': 'solarized'}
  let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }
  noremap <silent><leader>tn :tabn<cr>
  noremap <silent><leader>tp :tabp<cr>
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
  noremap <silent><s-tab> :tabnext<CR>
  inoremap <silent><s-tab> <ESC>:tabnext<CR>
endif

if (FindPlug('vim-expand-region') != -1)
  xmap v <Plug>(expand_region_expand)
  xmap V <Plug>(expand_region_shrink)
  let g:expand_region_text_objects = {
        \ 'iw'  :0,
        \ 'iW'  :0,
        \ 'i"'  :0,
        \ 'i''' :0,
        \ 'i]'  :1,
        \ 'ib'  :1,
        \ 'iB'  :1,
        \ 'il'  :1,
        \ 'ii'  :1,
        \ 'ip'  :0,
        \ 'ie'  :0,
        \ }
endif

if (FindPlug('gina') != -1)
  nnoremap <silent> <leader>gs     :Gina status<CR>
  nnoremap <silent> <leader>gr     :Gina branch<CR>
  nnoremap <silent> <leader>gU     :Gina reset -q %<CR>
  nnoremap <silent> <leader>gc     :Gina commit -v<CR>
  nnoremap <silent> <leader>gca    :Gina commit -a<CR>
  nnoremap <silent> <leader>gca!   :Gina commit -a --amend<CR>
  nnoremap <silent> <leader>gd     :Gina diff<CR>
  nnoremap <silent> <leader>gd.    :Gina diff %<CR>
  nnoremap <silent> <leader>gds    :Gina diff --staged<CR>
  nnoremap <silent> <leader>gp     :Gina push<CR>
  nnoremap <silent> <leader>ga     :Gina add %<CR>
  nnoremap <silent> <leader>gA     :Gina add .<CR>
  nnoremap <silent> <leader>gl     :Gina pull<CR>
  nnoremap <silent> <leader>glo    :Gina log<CR>
  nnoremap <silent> <leader>gb     :Gina blame<CR>
  nnoremap <silent> <leader>gm     :Gina compare<CR><C-w>L
endif

if (FindPlug('LanguageClient-neovim') != -1)
  " Required for operations modifying multiple buffers like rename.
  set hidden
  nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
  nnoremap <silent> <leader>lr :call LanguageClient_textDocument_rename()<CR>
  nnoremap <silent> <leader>lc :call LanguageClient_contextMenu()<CR>

  "pip3 install python-language-server
  let g:LanguageClient_serverCommands = {
        \ 'python': ['pyls'],
        \ }
endif

if (FindPlug('neosnippet.vim') != -1)
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)

  " SuperTab like snippets behavior.
  " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
  "imap <expr><TAB>
  " \ pumvisible() ? "\<C-n>" :
  " \ neosnippet#expandable_or_jumpable() ?
  " \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

  " For conceal markers.
  if has('conceal')
    set conceallevel=2 concealcursor=niv
  endif
endif

if (FindPlug('asyncomplete.vim') != -1) "{{{
  let g:asyncomplete_remove_duplicates = 1

  "let g:lsp_log_verbose = 1
  "let g:lsp_log_file = expand('~/vim-lsp.log')
  "let g:asyncomplete_log_file = expand('~/asyncomplete.log')

  if (FindPlug('tmux-complete.vim') != -1)
    let g:tmuxcomplete#asyncomplete_source_options = {
          \ 'name':      'tmuxcomplete',
          \ 'whitelist': ['*'],
          \ 'config': {
          \     'splitmode':      'words',
          \     'filter_prefix':   1,
          \     'show_incomplete': 1,
          \     'sort_candidates': 0,
          \     'scrollback':      0,
          \     'truncate':        0
          \     }
          \ }
  endif
  if (FindPlug('asyncomplete-buffer.vim') != -1)
    call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'whitelist': ['*'],
          \ 'blacklist': ['go'],
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ }))
  endif
  if (FindPlug('asyncomplete-necosyntax.vim') != -1)
    autocmd fcying_au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
          \ 'name': 'necosyntax',
          \ 'whitelist': ['*'],
          \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
          \ }))
  endif
  if (FindPlug('asyncomplete-file.vim') != -1)
    autocmd fcying_au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
          \ 'name': 'file',
          \ 'whitelist': ['*'],
          \ 'priority': 10,
          \ 'completor': function('asyncomplete#sources#file#completor')
          \ }))
  endif
  if (FindPlug('asyncomplete-tags.vim') != -1)
    autocmd fcying_au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
          \ 'name': 'tags',
          \ 'whitelist': ['c','cpp'],
          \ 'completor': function('asyncomplete#sources#tags#completor'),
          \ 'config': {
          \    'max_file_size': 50000000,
          \  },
          \ }))
  endif
  if (FindPlug('asyncomplete-necovim.vim') != -1)
    autocmd fcying_au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
          \ 'name': 'necovim',
          \ 'whitelist': ['vim'],
          \ 'completor': function('asyncomplete#sources#necovim#completor'),
          \ }))
  endif
  if (FindPlug('asyncomplete-omni.vim') != -1)
    call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
          \ 'name': 'omni',
          \ 'whitelist': ['*'],
          \ 'blacklist': ['c', 'cpp', 'html'],
          \ 'completor': function('asyncomplete#sources#omni#completor')
          \  }))
  endif
endif "}}}

if (FindPlug('vim-lsp') != -1)
  ""go get -u -v github.com/GeertJohan/go.rice
  ""git clone https://github.com/saibing/bingo.git && cd bingo && go install
  "if executable('bingo')
  "  au User lsp_setup call lsp#register_server({
  "        \ 'name': 'bingo',
  "        \ 'cmd': {server_info->['bingo', '-mode', 'stdio']},
  "        \ 'whitelist': ['go'],
  "        \ })
  "endif
  "go get -u github.com/sourcegraph/go-langserver
  if executable('go-langserver')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'go-lsp',
          \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
          \ 'whitelist': ['go'],
          \ })
  endif
endif

if (FindPlug('YouCompleteMe') != -1) "{{{
  "let g:ycm_key_list_select_completion=['<c-n>']
  let g:ycm_key_list_select_completion = ['<Down>']
  "let g:ycm_key_list_previous_completion=['<c-p>']
  let g:ycm_key_list_previous_completion = ['<Up>']
  let g:ycm_complete_in_comments = 1
  let g:ycm_complete_in_strings = 1
  let g:ycm_use_ultisnips_completer = 0
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax=1
  let g:ycm_key_list_stop_completion = ['<CR>']

  let g:ycm_seed_identifiers_with_syntax=1

  let g:ycm_goto_buffer_command = 'horizontal-split'
  let g:ycm_register_as_syntastic_checker = 0
  nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
  nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>

  if !empty(glob(g:config_dir . 'plug/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'))
    let g:ycm_global_ycm_extra_conf = g:config_dir . 'plug/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
  endif

  " let g:ycm_key_invoke_completion = '<C-Space>'
  let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'gitcommit' : 1,
        \}
endif "}}}

if (FindPlug('jedi-vim') != -1)
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#goto_command = '<leader>d'
  let g:jedi#goto_assignments_command = ''  " dynamically done for ft=python.
  let g:jedi#goto_definitions_command = ''  " dynamically done for ft=python.
  let g:jedi#use_tabs_not_buffers = 0       " current default is 1.
  let g:jedi#rename_command = '<Leader>gR'
  let g:jedi#usages_command = '<Leader>gu'
  let g:jedi#completions_enabled = 0
  let g:jedi#smart_auto_mappings = 1

  " Unite/ref and pydoc are more useful.
  let g:jedi#documentation_command = '<Leader>K'
  let g:jedi#auto_close_doc = 1
endif

if (FindPlug('coc') != -1)
  imap <c-l> coc#refresh()
endif

if (FindPlug('ncm2') != -1)
  "let $NVIM_PYTHON_LOG_FILE="/home/pub/ncm2_log"
  "let $NVIM_NCM_LOG_LEVEL="DEBUG"
  "let $NVIM_NCM_MULTI_THREAD=0

  set shortmess+=c
  " note that must keep noinsert in completeopt, the others is optional
  set completeopt=noinsert,menuone,noselect

  autocmd fcying_au InsertEnter * call ncm2#enable_for_buffer()
  let g:ncm2#matcher = 'substrfuzzy'
  "let g:ncm2#sorter = 'abbrfuzzy'
  if !exists('g:ncm2_pyclang#library_path')
    if g:is_win
      let g:ncm2_pyclang#library_path = 'd:\tool\scoop\apps\llvm\current\bin\'
    else
      let g:ncm2_pyclang#library_path = '/usr/lib/llvm-6.0/lib/libclang.so.1'
    endif
  endif

  if (FindPlug('ncm2-pyclang') != -1)
    let g:ncm2_pyclang#args_file_path = ['.git/.clang_complete', '.clang_complete']
    "autocmd fcying_au FileType c,cpp nnoremap <buffer> gd :<c-u>call ncm2_pyclang#goto_declaration()<cr>
  endif
endif

if (FindPlug('deoplete.nvim') != -1) "{{{
  set isfname-==
  autocmd fcying_au InsertEnter * call deoplete#enable()

  call deoplete#custom#option({
        \ 'smart_case': v:true,
        \ 'camel_case': v:true,
        \ 'ignore_sources': {},
        \ })

  call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])
  call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)

  " jedi clangx gtags LanguageClient
  call deoplete#custom#option('sources', {
        \ 'c': ['buffer', 'clangx', 'gtags'],
        \ 'cpp': ['buffer', 'clangx', 'gtags'],
        \ 'python': ['buffer', 'jedi'],
        \ })

  call deoplete#custom#option('keyword_patterns', {
        \ '_': '[a-zA-Z_]\k*',
        \ 'tex': '\\?[a-zA-Z_]\w*',
        \ 'ruby': '[a-zA-Z_]\w*[!?]?',
        \ })

  "call deoplete#custom#option('omni_patterns', {
  "  \ 'c': '\(\.\|->\)',
  "  \ 'cpp': '\(\.\|->\)',
  "  \ })

  call deoplete#custom#var('clangx', 'clang_file_path', ['.git/.clang_complete', '.clang_complete'])

  let g:deoplete#sources#jedi#server_timeout = 10
  let g:deoplete#sources#jedi#python_path = 'python3'

  "call deoplete#custom#option('profile', v:true)
  "call deoplete#enable_logging('DEBUG', 'deoplete.log')
  "call deoplete#custom#source('jedi', 'is_debug_enabled', 1)
  "let g:deoplete#sources#jedi#debug_server = "jedi.log"

  inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
endif "}}}

if (FindPlug('neocomplete') != -1) "{{{
  let g:neocomplete#data_directory= g:config_dir . '/.cache/neocomplete'
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

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries =
        \ {
        \ 'default' : '',
        \ 'vimshell' : g:config_dir . '/.cache/vimshell/command-history',
        \ 'java' : g:config_dir . '/.cache/dict/java.dict',
        \ 'ruby' : g:config_dir . '/.cache/dict/ruby.dict',
        \ 'scala' : g:config_dir . '/.cache/dict/scala.dict',
        \ }

  let g:neocomplete#enable_auto_delimiter = 1

  " neco-vim
  if !exists('g:necovim#complete_functions')
    let g:necovim#complete_functions = {}
  endif
  let g:necovim#complete_functions.Ref =
        \ 'ref#complete'

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ =
        \ get(g:neocomplete#keyword_patterns, '_', '\h\k*(\?')

  " AutoComplPop like behavior.
  let g:neocomplete#enable_auto_select = 0

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  let g:neocomplete#sources#omni#input_patterns.perl =
        \ get(g:neocomplete#sources#omni#input_patterns, 'perl',
        \ '\h\w*->\h\w*\|\h\w*::')
  let g:neocomplete#sources#omni#input_patterns.java =
        \ get(g:neocomplete#sources#omni#input_patterns, 'java',
        \ '[^. \t0-9]\.\w*')
  let g:neocomplete#sources#omni#input_patterns.lua =
        \ get(g:neocomplete#sources#omni#input_patterns, 'lua',
        \ '[^. \t0-9]\.\w*')
  let g:neocomplete#sources#omni#input_patterns.c =
        \ get(g:neocomplete#sources#omni#input_patterns, 'c',
        \ '[^.[:digit:] *\t]\%(\.\|->\)')
  let g:neocomplete#sources#omni#input_patterns.cpp =
        \ get(g:neocomplete#sources#omni#input_patterns, 'cpp',
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::')
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  "let g:neocomplete#force_omni_input_patterns.java = '^\s*'

  autocmd fcying_au FileType python setlocal omnifunc=jedi#completions
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#smart_auto_mappings = 0
  let g:neocomplete#force_omni_input_patterns.python =
        \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
  " alternative pattern: '\h\w*\|[^. \t]\.\w*'

  " <C-h>, <BS>: close popup and delete backword char.
  "inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  "inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
  inoremap <expr><C-l>  neocomplete#start_manual_complete()
  inoremap <expr><C-x><c-u>  neocomplete#start_manual_complete()
endif "}}}

if (FindPlug('completor') != -1)
  let g:completor_python_binary = 'python3'
endif

if (FindPlug('vim-visual-multi') != -1)
  let g:VM_no_meta_mappings = 1
  let g:VM_maps = {}
  let g:VM_maps['Find Under']         = '<C-n>'
  let g:VM_maps['Find Subword Under'] = '<C-n>'
  let g:VM_cmdheight = 3
  "let g:VM_manual_infoline = 1
endif

if (FindPlug('vim-multiple-cursors') != -1)
  "let g:multi_cursor_next_key='<S-n>'
  "let g:multi_cursor_prev_key='<S-p>'
  "let g:multi_cursor_skip_key='<S-x>'
  let g:multi_cursor_quit_key='<Esc>'
  " Called once right before you start selecting multiple cursors
  function! Multiple_cursors_before()
    let g:multiple_cursors_temp = &foldmethod
    set foldmethod=manual
    if exists(':NeoCompleteLock')==2
      exe 'NeoCompleteLock'
    endif
    if (FindPlug('deoplete') != -1)
      call deoplete#custom#buffer_option('auto_complete', v:false)
    endif
    if (FindPlug('ncm2') != -1)
      call ncm2#lock('vim-multiple-cursors')
    endif
  endfunction

  " Called once only when the multiple selection is canceled (default <Esc>)
  function! Multiple_cursors_after()
    let &foldmethod = g:multiple_cursors_temp
    if exists(':NeoCompleteUnlock')==2
      exe 'NeoCompleteUnlock'
    endif
    if (FindPlug('deoplete') != -1)
      call deoplete#custom#buffer_option('auto_complete', v:true)
    endif
    if (FindPlug('ncm2') != -1)
      call ncm2#unlock('vim-multiple-cursors')
    endif
  endfunction
endif

if (FindPlug('nerdtree') != -1)
  nmap <leader>nt :NERDTreeToggle<cr>
  nmap <leader>nf :NERDTreeFind<cr>
  nmap <F12> :NERDTreeToggle<cr>
  let g:NERDTreeWinSize=32
  let g:NERDTreeWinPos='right'
  let g:NERDTreeShowHidden=1
  let g:NERDTreeMinimalUI=1
  let g:NERDTreeAutoDeleteBuffer=1
  let g:NERDTreeShowBookmarks=1
  let g:NERDTreeShowLineNumbers=1
  let g:NERDTreeShowHidden=1
endif

if (FindPlug('ctrlsf') != -1)
  "let g:ctrlsf_debug_mode = 1
  "redir! > ctrlsf.log
  let g:ctrlsf_ackprg = 'rg'
  let g:ctrlsf_regex_pattern = 1
  let g:ctrlsf_case_sensitive = 'smart'
  let g:ctrlsf_default_root = 'cwd'
  let g:ctrlsf_default_view_mode = 'normal'
  let g:ctrlsf_search_mode = 'async'
  let g:ctrlsf_auto_focus = {
        \ 'at': 'done',
        \ 'duration_less_than': 1000
        \ }

  nmap <leader>sf <Plug>CtrlSFCwordExec
  nmap <leader>sF <Plug>CtrlSFPrompt
  vmap <leader>sf <Plug>CtrlSFVwordExec
  vmap <leader>sF <Plug>CtrlSFVwordPath
  nmap <leader>sp <Plug>CtrlSFPwordPath
  nnoremap <leader>so :CtrlSFOpen<CR>
  nnoremap <leader>st :CtrlSFToggle<CR>
  inoremap <leader>st <Esc>:CtrlSFToggle<CR>

  let g:ctrlsf_mapping = {
        \ 'next'    : 'n',
        \ 'prev'    : 'N',
        \ }

  autocmd fcying_au FileType ctrlsf call s:ctrlsf_settings()
  function! s:ctrlsf_settings()
    nmap <buffer> <c-j> np
    nmap <buffer> <c-k> Np
  endfunction
endif

if (FindPlug('vim-session') != -1)
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif

if (FindPlug('LeaderF') != -1)
  let g:Lf_PreviewCode = 0
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_DefaultMode = 'FullPath'
  let g:Lf_RootMarkers = ['.root', '.git']
  let g:Lf_WildIgnore = {
        \ 'dir': ['.root','.svn','.git','.hg'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \}

  let g:Lf_CommandMap = {'<F5>': ['<C-L>']}
  let g:Lf_RgConfig = [
        \ "--glob=!git/*",
        \ "--glob=!**/.repo/*",
        \ "--glob=!**/.ccache/*",
        \ "--glob=!**/GTAGS",
        \ "--glob=!**/GRTAGS",
        \ "--glob=!**/GPATH",
        \ "--glob=!**/tags",
        \ "--glob=!**/prj_tags",
        \ "--glob=!**/.clang_complete",
        \ "--iglob=!**/obj/*",
        \ "--iglob=!**/out/*",
        \ "--hidden"
        \ ]

  nnoremap ff :<C-u>Leaderf file<CR>
  nnoremap fb :<C-u>Leaderf buffer<CR>
  nnoremap fo :<C-u>Leaderf function<CR>
  nnoremap ft :<C-u>Leaderf tag<CR>
  nnoremap fm :<C-u>Leaderf mru<CR>
  nnoremap fh :<C-u>Leaderf searchHistory<CR>
  nnoremap fl :<C-u>Leaderf line --regex<CR>
  nnoremap ft :<C-U>Leaderf! rg --recall<CR>
  nnoremap fg :<C-u><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>
  nnoremap fG :<C-u><C-R>=printf("Leaderf! rg -e ")<CR>
  xnoremap fg :<C-u><C-R>=printf("Leaderf! rg -F -e %s", leaderf#Rg#visual())<CR><CR>
  xnoremap fG :<C-u><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
  nnoremap fs :<C-u>CtrlSF 
  nnoremap fi :exec "Leaderf file --regex --input " . <SID>StripInclude(getline("."))<CR>
  function! s:StripInclude(line)
    let l:strip_include = substitute(a:line, '\v.*[\<"]([a-zA-Z0-9_/\.]+)[\>"]', '\1', 'g')
    return l:strip_include
  endfunction
endif

if (FindPlug('denite') != -1) "{{{
  if executable('rg')
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('file_rec', 'command',
          \ ['rg', '--files', '--hidden', '--follow',
          \ '-g','!out', '-g','!obj', '-g', '!deploy',
          \ '-g','!tags', '-g','!GTAGS', '-g','!GRTAGS', '-g','!GPATH',
          \ '-g', '!.git', '-g', '!.svn'])
    call denite#custom#var('grep', 'default_opts',
          \ ['--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  elseif executable('pt')
    call denite#custom#var('grep', 'command', ['pt'])
    call denite#custom#var('file_rec', 'command',
          \ ['pt', '--follow', '--nocolor', '--nogroup', '--hidden',
          \ '--ignore','lib', '--ignore','obj', '--ignore','out',
          \ '--ignore','deploy',
          \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
          \ '--ignore','.git', '--ignore','.svn', '-g', ''])
    call denite#custom#var('grep', 'default_opts',
          \ ['--nogroup', '--nocolor', '--smart-case', '--hidden',
          \ '--ignore','lib', '--ignore','obj', '--ignore','out',
          \ '--ignore','deploy',
          \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
          \ '--ignore','.git', '--ignore','.svn'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  endif

  call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
        \ [ '.git/', '.ropeproject/', '__pycache__/',
        \ 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

  call denite#custom#source('file_mru', 'converters',
        \ ['converter_relative_word'])

  " Change matchers.
  call denite#custom#source('file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
  "call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])

  " Change sorters.
  call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])

  nnoremap [Denite] <Nop>
  nmap f [Denite]
  nmap <c-p> [Denite]
  nnoremap [Denite]f :<C-u>Denite file_rec<CR>
  "nnoremap [Denite]f :<C-u>FZF<CR>
  nnoremap [Denite]F :<C-u>Denite file_rec
  nnoremap [Denite]b :<C-u>Denite buffer bookmark<CR>
  nnoremap [Denite]g :<C-u>Denite grep:.<CR>
  nnoremap [Denite]l :<C-u>Denite line<CR>
  nnoremap [Denite]o :<C-u>Denite outline<CR>
  nnoremap [Denite]h :<C-u>Denite history/yank<CR>
  nnoremap [Denite]m :<C-u>Denite file_mru<CR>
  nnoremap [Denite]p :<C-u>Denite jump_point file_point<CR>
  "nnoremap [Denite]s :<C-u>Denite source<CR>

  " KEY MAPPINGS
  let s:insert_mode_mappings = [
        \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
        \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
        \ ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
        \ ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
        \ ['<C-t>', '<denite:move_to_first_line>', 'noremap'],
        \ ['<C-b>', '<denite:move_to_last_line>', 'noremap'],
        \ ]

  let s:normal_mode_mappings = [
        \ ["'", '<denite:toggle_select_down>', 'noremap'],
        \ ['<C-t>', '<denite:move_to_first_line>', 'noremap'],
        \ ['<C-b>', '<denite:move_to_last_line>', 'noremap'],
        \ ['st', '<denite:do_action:tabopen>', 'noremap'],
        \ ['sh', '<denite:do_action:vsplit>', 'noremap'],
        \ ['sv', '<denite:do_action:split>', 'noremap'],
        \ ]

  for s:m in s:insert_mode_mappings
    call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
  endfor
  for s:m in s:normal_mode_mappings
    call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
  endfor

  unlet s:m s:insert_mode_mappings s:normal_mode_mappings
endif "}}}

if (FindPlug('vim-choosewin') != -1)
  nmap - <Plug>(choosewin)
endif

if (FindPlug('vim-bookmarks') != -1)
  nmap <Leader>m <Plug>BookmarkToggle
  nmap <Leader>mi <Plug>BookmarkAnnotate
  nmap <Leader>ma <Plug>BookmarkShowAll
  nmap <Leader>mj <Plug>BookmarkNext
  nmap <Leader>mk <Plug>BookmarkPrev
  nmap <Leader>mc <Plug>BookmarkClear
  nmap <Leader>mx <Plug>BookmarkClearAll
endif

if (FindPlug('vim-ref') != -1)
  let g:ref_source_webdict_sites = {
        \   'je': {
        \     'url': 'http://dictionary.infoseek.ne.jp/jeword/%s',
        \   },
        \   'ej': {
        \     'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
        \   },
        \   'wiki': {
        \     'url': 'http://ja.wikipedia.org/wiki/%s',
        \   },
        \   'cn': {
        \     'url': 'http://www.iciba.com/%s',
        \   },
        \   'wikipedia:en':{'url': 'http://en.wikipedia.org/wiki/%s',  },
        \   'bing':{'url': 'http://cn.bing.com/search?q=%s', },
        \ }
  let g:ref_source_webdict_sites.default = 'cn'
  "let g:ref_source_webdict_cmd='lynx -dump -nonumbers %s'
  "let g:ref_source_webdict_cmd='w3m -dump %s'
  "The filter on the output. Remove the first few lines
  function! g:ref_source_webdict_sites.je.filter(output)
    return join(split(a:output, "\n")[15 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.ej.filter(output)
    return join(split(a:output, "\n")[15 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.wiki.filter(output)
    return join(split(a:output, "\n")[17 :], "\n")
  endfunction
  nnoremap <Leader>rj :<C-u>Ref webdict je<Space>
  nnoremap <Leader>re :<C-u>Ref webdict ej<Space>
  nnoremap <Leader>rc :<C-u>Ref webdict cn<Space>
  nnoremap <Leader>rw :<C-u>Ref webdict wikipedia:en<Space>
  nnoremap <Leader>rb :<C-u>Ref webdict bing<Space>
endif

if (FindPlug('fencview') != -1)
  let g:fencview_autodetect = 1
  let g:fencview_checklines = 10
endif

if (FindPlug('nerdcommenter') != -1)
  let g:NERDCreateDefaultMappings = 0
  let g:NERDSpaceDelims = 0
  "let g:NERDRemoveExtraSpaces = 0
  let g:NERDCommentEmptyLines = 1
  let g:NERDDefaultAlign = 'left'
  let g:NERDToggleCheckAllLines = 1
  let g:NERDCustomDelimiters = {
        \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
        \ 'cpp': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
        \ 'go': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
        \ 'qml': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
        \ 'conf': { 'left': '#' },
        \ 'aptconf': { 'left': '//' },
        \ 'rc': { 'left': '#' },
        \ '': { 'left': '#' },
        \ }
  nmap <A-/> <plug>NERDCommenterToggle
  vmap <A-/> <plug>NERDCommenterToggle gv
  nmap gc <plug>NERDCommenterToggle
  vmap gc <plug>NERDCommenterToggle
  vmap gC <plug>NERDCommenterComment
  vmap gU <plug>NERDCommenterUncomment
  nmap gi <plug>NERDCommenterInvert
  vmap gi <plug>NERDCommenterInvert
  nmap gs <plug>NERDCommenterSexy
  vmap gs <plug>NERDCommenterSexy
endif

if (FindPlug('tagbar') != -1) "{{{
  nnoremap <silent><Leader>tt :TagbarToggle<CR>
  nnoremap <silent><F11> :TagbarToggle<CR>
  let g:tagbar_left=1
  let g:tagbar_width=32
  let g:tagbar_compact=1
  let g:tagbar_type_go = {
        \ 'ctagstype' : 'go',
        \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
        \ },
        \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
        \ },
        \ 'ctagsbin'  : 'gotags',
        \ 'ctagsargs' : '-sort -silent'
        \ }
endif "}}}

if (FindPlug('vim-bbye') != -1)
  :nnoremap <Leader>q :Bdelete<CR>
endif

if (FindPlug('vim-easymotion') != -1)
  let g:EasyMotion_smartcase = 0
  let g:EasyMotion_do_mapping = 0   " Disable default mappings
  " <Leader>f{char} to move to {char}
  map  <Leader>f <Plug>(easymotion-bd-f)
  nmap <Leader>f <Plug>(easymotion-overwin-f)
  " s{char}{char} to move to {char}{char}
  nmap s <Plug>(easymotion-overwin-f2)
  " Move to line
  map <Leader>L <Plug>(easymotion-bd-jk)
  nmap <Leader>L <Plug>(easymotion-overwin-line)
  " Move to word
  map  <Leader>w <Plug>(easymotion-bd-w)
  nmap <Leader>w <Plug>(easymotion-overwin-w)
endif

if (FindPlug('vim-fswitch') != -1)
  map <silent> <Leader>h <ESC>:FSHere<CR>
endif

if (FindPlug('vimshell') != -1)
  nnoremap <leader>vs :silent VimShell<CR>
  let g:vimshell_prompt_expr =
        \ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
  let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
  let g:vimshell_no_default_keymappings=0
endif

"if (FindPlug('delimitMate') != -1)
"    autocmd fcying_au FileType python let b:delimitMate_nesting_quotes = ['"']
"endif

"}}}
