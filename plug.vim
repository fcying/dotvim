" deoplete ncm2 asyncomplete ycm completor coc
let g:complete_func = get(g:, 'complete_func', 'ncm2')


" ============================================================================
" plugin {{{
" ============================================================================
let g:plug_dir = g:config_dir . '/plugged'
if filereadable(expand(g:plug_dir . '/vim-plug/plug.vim')) == 0
  if executable('git')
    if filereadable(expand(g:file_vimrc_local)) == 0
      call writefile([
            \ 'let g:complete_func=''ncm2''',
            \ '"let g:colorscheme=''molokai''',
            \ 'function! LoadAfter()',
            \ 'endfunc',
            \ ], expand(g:file_vimrc_local), 'a')
    endif
    silent exec '!git clone --depth 1 https://github.com/junegunn/vim-plug '
          \ . g:plug_dir . '/vim-plug'
    autocmd myau VimEnter * PlugInstall --sync | source $MYVIMRC
  else
    echohl WarningMsg
    echom 'You need install git!'
    echohl None
  endif
else
  autocmd myau VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall --sync | q
        \| endif
endif
exec 'source '. g:plug_dir . '/vim-plug/plug.vim'
call plug#begin(expand(g:plug_dir))

Plug 'junegunn/vim-plug'
Plug 'mbbill/fencview'
Plug 'adah1972/tellenc'
Plug 'bogado/file-line'
Plug 'tpope/vim-eunuch'
Plug 'moll/vim-bbye', {'on':'Bdelete'}
Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 't9md/vim-choosewin', {'on':'<Plug>(choosewin)'}
Plug 'scrooloose/nerdtree', {'on':['NERDTreeToggle', 'NERDTreeFind']}
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar', {'on':'TagbarToggle'}
Plug 'easymotion/vim-easymotion'

Plug 'aperezdc/vim-template', {'on':'TemplateHere'}
Plug 'Vimjas/vim-python-pep8-indent', {'for':'python'}
Plug 'cespare/vim-toml'
Plug 'peterhoeg/vim-qml'
"Plug 'ekalinin/Dockerfile.vim'
Plug 'wsdjeg/vim-autohotkey', {'for':'autohotkey'}
Plug 'godlygeek/tabular', {'for':'markdown'}
Plug 'plasticboy/vim-markdown', {'for':'markdown'}

function! InstallLeaderF(info) abort
  if a:info.status !=# 'unchanged' || a:info.force
    silent !echo "InstallLeaderF"
    if g:is_win
      silent !.\install.bat
    else
      silent !./install.sh
    endif
    silent !pip3 install pygments --upgrade
  endif
endfunction
Plug 'Yggdroot/LeaderF', {'do': function('InstallLeaderF')}
Plug 'wsdjeg/FlyGrep.vim'

Plug 'tweekmonster/startuptime.vim', {'on':'StartupTime'}
Plug 'MattesGroeger/vim-bookmarks'
Plug 'thinca/vim-ref'
Plug 'derekwyatt/vim-fswitch'
Plug 'nathanaelkane/vim-indent-guides', {'on':'<Plug>IndentGuidesToggle'}
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'dyng/ctrlsf.vim'
"Plug 'lambdalisue/gina.vim', {'on': 'Gina'}
"Plug 'tpope/vim-fugitive'

Plug 'skywind3000/vim-preview'
Plug 'skywind3000/asyncrun.vim'
Plug 'fcying/gen_clang_conf.vim'
Plug 'mattn/emmet-vim'
"Plug 'w0rp/ale'

function! UpdateLsp() abort
  "silent !rustup update
  "silent !rustup component add rls rust-analysis rust-src
  "silent !npm install -g typescript typescript-language-server
  "silent !npm install -g dockerfile-language-server-nodejs
  silent !pip3 install python-language-server --upgrade
endfunction

function! InstallVimLsp(info) abort
  "call UpdateLsp()
endfunction

function! InstallLanguageClient(info) abort
  if a:info.status !=# 'unchanged' || a:info.force
    if g:is_win
      silent !powershell -executionpolicy bypass -File install.ps1
    else
      silent !bash install.sh
    endif
    call UpdateLsp()
  endif
endfunction

if g:complete_func ==# 'ncm2'
  function! InstallNcm2(info) abort
    if a:info.status !=# 'unchanged' || a:info.force
      silent !echo "InstallNcm2"
      if g:is_nvim ==# 0
        silent !pip3 install neovim --upgrade
      endif
    endif
  endfunction
  if g:is_nvim ==# 0
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'roxma/nvim-yarp'
  Plug 'ncm2/ncm2', {'do': function('InstallNcm2')}
  "Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': function('InstallLanguageClient')}
  Plug 'ncm2/ncm2-vim-lsp'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp', {'do': function('InstallVimLsp')}
  Plug 'mattn/vim-lsp-settings'
  if g:is_win ==# 0
    Plug 'ncm2/ncm2-tmux'
  endif
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-gtags'
  Plug 'yuki-ycino/ncm2-dictionary'
  Plug 'ncm2/ncm2-cssomni'
  Plug 'ncm2/ncm2-html-subscope'
  Plug 'ncm2/ncm2-vim'
  Plug 'Shougo/neco-vim'
  Plug 'ncm2/ncm2-syntax'
  Plug 'Shougo/neco-syntax'
  "Plug 'ncm2/ncm2-pyclang'
  Plug 'ncm2/ncm2-ultisnips'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  "curl https://sh.rustup.rs -sSf | sh
  "rustup toolchain add nightly && cargo +nightly install racer && rustup component add rust-src
  "Plug 'ncm2/ncm2-racer'
  "Plug 'ncm2/ncm2-go'
  "Plug 'ncm2/ncm2-jedi'
elseif g:complete_func ==# 'deoplete'
  function! InstallDeoplete(info) abort
    if a:info.status !=# 'unchanged' || a:info.force
      silent !echo "InstallDeoplete"
      if g:is_nvim
        silent UpdateRemotePlugins
      else
        silent !pip3 install neovim --upgrade
      endif
      silent !pip3 install python-language-server --upgrade
    endif
  endfunction
  Plug 'Shougo/deoplete.nvim', {'do': function('InstallDeoplete')}
  if g:is_nvim ==# 0
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'Shougo/neco-syntax'
  Plug 'Shougo/neoinclude.vim'
  Plug 'Shougo/neco-vim'
  Plug 'Shougo/deoplete-clangx'
  Plug 'zchee/deoplete-jedi'
  " for goto feature
  Plug 'davidhalter/jedi-vim'
  if g:has_go
    function! InstallDeopleteGo(info) abort
      if a:info.status !=# 'unchanged' || a:info.force
        if g:is_win
          silent !mingw32-make
        else
          silent !make
        endif
        silent !pip3 install pygments --upgrade
      endif
    endfunction
    Plug 'zchee/deoplete-go', {'do': function('InstallDeopleteGo')}
  endif
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
elseif g:complete_func ==# 'coc'
  function! InstallCoc(info) abort
    if a:info.status !=# 'unchanged' || a:info.force
      if g:is_win
        call system('.\install.cmd')
      else
        call system('./install.sh')
      endif

      silent !mkdir -p ~/.npm
      silent !cd ~/.npm 
      silent !npm install dockerfile-language-server-nodejs
      if g:has_go
        GoGetTools
      endif
    endif
  endfunction
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': function('InstallCoc')}
  Plug 'honza/vim-snippets'
elseif g:complete_func ==# 'asyncomplete'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp', {'do': function('InstallVimLsp')}
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'mattn/vim-lsp-settings'
  Plug 'SirVer/ultisnips'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'kyouryuukunn/asyncomplete-neoinclude.vim'
  Plug 'yami-beta/asyncomplete-omni.vim'
  if g:is_win ==# 0
    Plug 'wellle/tmux-complete.vim'
  endif
  Plug 'prabirshrestha/asyncomplete-tags.vim'
  Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
  Plug 'prabirshrestha/asyncomplete-necovim.vim'
elseif g:complete_func ==# 'completor'
  Plug 'maralla/completor.vim'
  Plug 'Shougo/neoinclude.vim'
  Plug 'tokorom/completor-shell'
  Plug 'masawada/completor-dictionary'
  Plug 'ferreum/completor-tmux'
elseif g:complete_func ==# 'ycm'
  Plug 'Valloric/YouCompleteMe'
endif

"color
Plug 'tomasr/molokai'
"Plug 'altercation/vim-colors-solarized'
Plug 'fcying/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
call plug#end()
delc PlugUpgrade
nnoremap <leader>pu :PlugUpdate<CR>:redraw!<CR>
nnoremap <leader>pi :PlugInstall<CR>:redraw!<CR>
nnoremap <leader>pc :PlugClean<CR>:redraw!<CR>



" ============================================================================
" plugin settings {{{
" ============================================================================
function! FindPlug(plugname) abort
  return index(g:plugs_order, a:plugname)
endfunction

" gen tags
nnoremap <silent> <leader>tg :GenClangConf<CR>:Leaderf gtags --update<CR>
nnoremap <silent> <leader>tc :ClearClangConf<CR>:Leaderf gtags --remove<CR>

if (FindPlug('vim-indent-guides') != -1)
  let g:indent_guides_enable_on_vim_startup=0
  let g:indent_guides_start_level=2
  let g:indent_guides_guide_size=1
  :nmap <silent> <Leader>i <Plug>IndentGuidesToggle
endif

if (FindPlug('asyncrun.vim') != -1)
  let g:asyncrun_bell = 1
  let g:asyncrun_silent = 0
  "let g:asyncrun_open = 6
  autocmd myau User AsyncRunStop :call <SID>asyncrun_stop()
  function! s:asyncrun_stop()
    if (g:asyncrun_code ==# 0)
      cclose
      echo 'AsyncRun Success'
    else
      call ShowQuickfix()
    endif
  endfunction
endif

if (FindPlug('lightline.vim') != -1)
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

if (FindPlug('gina.vim') != -1)
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
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <silent> <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <silent> <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <silent> <leader>lx :call LanguageClient#textDocument_references()<CR>
  nnoremap <silent> <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <silent> <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <silent> <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <silent> <leader>lm :call LanguageClient_contextMenu()<CR>

  let g:LanguageClient_rootMarkers = {
        \ 'go': ['.root', '.git', 'go.mod'],
        \ 'c': ['.root', '.git'],
        \ 'cpp': ['.root', '.git'],
        \ }

  let g:LanguageClient_diagnosticsEnable = get(g:, 'LanguageClient_diagnosticsEnable', 0)

  let g:LanguageClient_serverCommands = {
        \ 'c': ['ccls'],
        \ 'cpp': ['ccls'],
        \ 'go' : ['gopls'],
        \ 'python': ['pyls'],
        \ 'rust': ['rustup', 'run', 'stable', 'rls'],
        \ 'javascript': ['javascript-typescript-stdio'],
        \ 'typescript': ['javascript-typescript-stdio'],
        \ 'dockerfile': ['docker-langserver --stdio'],
        \ }

endif

if (FindPlug('vim-lsp') != -1)
  let g:lsp_diagnostics_enabled = 0
  nnoremap <silent> <leader>ld :LspDefinition<CR>
  nnoremap <silent> <leader>lr :LspRename<CR>
  nnoremap <silent> <leader>lf :LspDocumentFormat<CR>
  nnoremap <silent> <leader>lt :LspTypeDefinition<CR>
  nnoremap <silent> <leader>lx :LspReferences<CR>
  nnoremap <silent> <leader>lc :LspCodeAction<CR>
  nnoremap <silent> <leader>lh :LspHover<CR>
  nnoremap <silent> <leader>ls :LspWorkspaceSymbol<CR>
  nnoremap <silent> <leader>lm :LspImplementation<CR>
endif

if (FindPlug('ale') != -1)
  nmap <silent> <leader>aj :ALENext<cr>
  nmap <silent> <leader>ak :ALEPrevious<cr>

  let g:ale_sh_shellcheck_exclusions = 'SC2164,SC2086,SC1090'

  let g:ale_linters = {
        \   'c': [],
        \}
endif

if (FindPlug('ultisnips') != -1)
  if (FindPlug('ncm2') != -1)
    inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')
  endif
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
  let g:UltiSnipsRemoveSelectModeMappings = 0
endif

if (FindPlug('neosnippet.vim') != -1)
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)

  if g:complete_func ==# 'ncm2'
    inoremap <silent> <expr> <CR> ncm2_neosnippet#expand_or("\<CR>", 'n')
  elseif g:complete_func ==# 'deoplete'
    " SuperTab like snippets behavior.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    "imap <expr><TAB>
    " \ pumvisible() ? "\<C-n>" :
    " \ neosnippet#expandable_or_jumpable() ?
    " \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  endif

  " For conceal markers.
  "if has('conceal')
  "  set conceallevel=2 concealcursor=niv
  "endif
endif

if (FindPlug('vim-lsp-settings') != -1) "{{{
  let g:lsp_settings_servers_dir = g:cache_dir . '/lsp_settings'
endif "}}}

if (FindPlug('asyncomplete.vim') != -1) "{{{
  let g:asyncomplete_remove_duplicates = 1

  "let g:lsp_log_verbose = 1
  "let g:lsp_log_file = expand('~/vim-lsp.log')
  "let g:asyncomplete_log_file = expand('~/asyncomplete.log')

  if (FindPlug('asyncomplete-buffer.vim') != -1)
    call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'whitelist': ['*'],
          \ 'blacklist': ['go'],
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ 'config': {
          \    'max_buffer_size': 5000000,
          \  },
          \ }))
  endif
  if (FindPlug('asyncomplete-file.vim') != -1)
    au myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
          \ 'name': 'file',
          \ 'whitelist': ['*'],
          \ 'priority': 10,
          \ 'completor': function('asyncomplete#sources#file#completor')
          \ }))
  endif
  if (FindPlug('asyncomplete-neoinclude.vim') != -1)
    au myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neoinclude#get_source_options({
          \ 'name': 'neoinclude',
          \ 'whitelist': ['cpp'],
          \ 'refresh_pattern': '\(<\|"\|/\)$',
          \ 'completor': function('asyncomplete#sources#neoinclude#completor'),
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
  if (FindPlug('asyncomplete-tags.vim') != -1)
    au myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
          \ 'name': 'tags',
          \ 'whitelist': ['c'],
          \ 'completor': function('asyncomplete#sources#tags#completor'),
          \ 'config': {
          \    'max_file_size': 50000000,
          \  },
          \ }))
  endif
  if (FindPlug('asyncomplete-necosyntax.vim') != -1)
    autocmd myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
          \ 'name': 'necosyntax',
          \ 'whitelist': ['*'],
          \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
          \ }))
  endif
  if (FindPlug('asyncomplete-necovim.vim') != -1)
    autocmd myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
          \ 'name': 'necovim',
          \ 'whitelist': ['vim'],
          \ 'completor': function('asyncomplete#sources#necovim#completor'),
          \ }))
  endif
endif "}}}

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

if (FindPlug('coc.nvim') != -1)
  let g:coc_extension_root = g:cache_dir . '/coc/extensions'
  "call coc#add_extension('coc-tabnine')
  call coc#add_extension('coc-vimlsp')
  "call coc#add_extension('coc-pairs')
  call coc#add_extension('coc-dictionary', 'coc-syntax')
  call coc#add_extension('coc-snippets', 'coc-json')
  call coc#add_extension('coc-rls', 'coc-python')
  call coc#add_extension('coc-css', 'coc-html')
  call coc#add_extension('coc-tsserver', 'coc-java')

  imap <c-l> coc#refresh()

  " pairs
  autocmd myau FileType markdown let b:coc_pairs_disabled = ['`']
  autocmd myau FileType vim let b:coc_pairs_disabled = ['"']

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  nmap <leader>rn <Plug>(coc-rename)

  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'coc#status'
        \ },
        \ }

  " snippets
  let g:coc_snippet_next = '<c-j>'
  let g:coc_snippet_prev = '<c-k>'
  imap <C-j> <Plug>(coc-snippets-expand-jump)
endif

if (FindPlug('ncm2') != -1)
  "let $NVIM_PYTHON_LOG_FILE="/home/pub/ncm2_log"
  "let $NVIM_NCM_LOG_LEVEL="DEBUG"
  "let $NVIM_NCM_MULTI_THREAD=0

  set shortmess+=c
  " note that must keep noinsert in completeopt, the others is optional
  set completeopt=noinsert,menuone,noselect
  let g:ncm2#complete_length = [[1,2],[7,1]]

  autocmd myau BufEnter * call ncm2#enable_for_buffer()
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
    let g:ncm2_pyclang#args_file_path = ['compile_flags.txt']
    "autocmd myau FileType c,cpp nnoremap <buffer> gd :<c-u>call ncm2_pyclang#goto_declaration()<cr>
  endif
endif

if (FindPlug('deoplete.nvim') != -1) "{{{
  set isfname-==
  autocmd myau InsertEnter * call deoplete#enable()

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

if (FindPlug('completor.vim') != -1)
  let g:completor_python_binary = 'python3'
endif

if (FindPlug('vim-visual-multi') != -1)
  let g:VM_no_meta_mappings = 1
  let g:VM_maps = {}
  let g:VM_maps['Find Under']         = '<C-n>'
  let g:VM_maps['Find Subword Under'] = '<C-n>'
  let g:VM_cmdheight = 1
  "let g:VM_manual_infoline = 1
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

if (FindPlug('ctrlsf.vim') != -1)
  "let g:ctrlsf_debug_mode = 1
  "redir! > ctrlsf.log
  let g:ctrlsf_ackprg = 'rg'
  let g:ctrlsf_regex_pattern = 1
  let g:ctrlsf_case_sensitive = 'no'
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

  let g:ctrlsf_mapping = {
        \ 'next'    : 'n',
        \ 'prev'    : 'N',
        \ }

  autocmd myau FileType ctrlsf call s:ctrlsf_settings()
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
  let g:Lf_WorkingDirectoryMode = 'c'
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_CacheDirectory = g:cache_dir
  let g:Lf_Gtagslabel = 'native-pygments'
  let $GTAGSCONF = g:etc_dir . '/gtags.conf'
  let g:Lf_DefaultMode = 'FullPath'
  let g:Lf_GtagsAutoGenerate = 0
  let g:Lf_RootMarkers = ['.root', '.git', '.svn']
  let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
  let g:Lf_WildIgnore = {
        \ 'dir': ['.root','.svn','.git','.hg','.ccls-cache'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]','.ccls']
        \}

  let g:Lf_CommandMap = {'<F5>': ['<C-L>']}
  let g:Lf_NormalMap = {
        \ 'File':   [['<ESC>', ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
        \ 'Buffer': [['<ESC>', ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
        \ 'Mru': [['<ESC>', ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
        \ 'Tag': [['<ESC>', ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
        \ 'BufTag': [['<ESC>', ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
        \ 'Function': [['<ESC>', ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
        \ }
  let g:Lf_RgConfig = [
        \ '--glob=!.git/*',
        \ '--glob=!.svn/*',
        \ '--glob=!.ccls',
        \ '--glob=!.ccls-cache',
        \ '--glob=!**/.repo/*',
        \ '--glob=!**/.ccache/*',
        \ '--glob=!**/GTAGS',
        \ '--glob=!**/GRTAGS',
        \ '--glob=!**/GPATH',
        \ '--glob=!**/tags',
        \ '--glob=!**/prj_tags',
        \ '--glob=!**/.clang_complete',
        \ '--iglob=!**/obj/*',
        \ '--iglob=!**/out/*',
        \ '--hidden'
        \ ]

  nnoremap ff :<C-u>Leaderf file<CR>
  nnoremap fb :<C-u>Leaderf buffer<CR>
  nnoremap fo :<C-u>Leaderf function<CR>
  nnoremap fm :<C-u>Leaderf mru<CR>
  nnoremap fh :<C-u>Leaderf searchHistory<CR>
  nnoremap fl :<C-u>Leaderf line --regex<CR>
  nnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -e %s", expand("<cword>"))<CR>
  nnoremap fG :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -e ")<CR>
  xnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -F -e %s", leaderf#Rg#visual())<CR>
  nnoremap fs :<C-u>CtrlSF
  nnoremap f/ :<C-u>FlyGrep<cr>
  nnoremap fi :exec "Leaderf file --regex --input " . <SID>StripInclude(getline("."))<CR>
  function! s:StripInclude(line)
    let l:strip_include = substitute(a:line, '\v.*[\<"]([a-zA-Z0-9_/\.]+)[\>"]', '\1', 'g')
    return l:strip_include
  endfunction
  noremap ftr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap ftd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
  "noremap <C-]> :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap fto :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
  noremap ftn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
  noremap ftp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
  nnoremap fr :<C-U>Leaderf --recall<CR>
endif

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
        \ 'json': { 'left': '//' },
        \ 'rc': { 'left': '#' },
        \ '': { 'left': '#' },
        \ }
  nmap <A-/> <plug>NERDCommenterToggle
  vmap <A-/> <plug>NERDCommenterToggle gv
  nmap <leader>gc <plug>NERDCommenterToggle
  vmap <leader>gc <plug>NERDCommenterToggle
  vmap <leader>gC <plug>NERDCommenterComment
  vmap <leader>gU <plug>NERDCommenterUncomment
  nmap <leader>gi <plug>NERDCommenterInvert
  vmap <leader>gi <plug>NERDCommenterInvert
  nmap <leader>gs <plug>NERDCommenterSexy
  vmap <leader>gs <plug>NERDCommenterSexy
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
  " move to {char}
  nmap s <Plug>(easymotion-overwin-f)
  " move to {char}{char}
  nmap <Leader>s <Plug>(easymotion-overwin-f2)
  " Move to line
  nmap <Leader>L <Plug>(easymotion-overwin-line)
  " Move to word
  nmap <Leader>w <Plug>(easymotion-overwin-w)
endif

if (FindPlug('vim-fswitch') != -1)
  nnoremap <silent> <Leader>h <ESC>:FSHere<CR>
endif

if (FindPlug('vimshell') != -1)
  nnoremap <leader>vs :silent VimShell<CR>
  let g:vimshell_prompt_expr =
        \ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
  let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
  let g:vimshell_no_default_keymappings=0
endif

if (FindPlug('emmet-vim') != -1)
  let g:user_emmet_install_global = 0
  autocmd myau FileType html,css EmmetInstall
endif

if (FindPlug('vim-template') != -1)
  nnoremap <silent> <Leader>th :TemplateHere<CR>
  nnoremap <silent> <Leader>tf :execute 'Template *.' . &filetype<CR>
  let g:templates_no_autocmd = 1
  exe 'let g:templates_directory = [''' . g:etc_dir . '/template'']'
  let g:user = get(g:, 'user', 'fcying')
  let g:email = get(g:, 'email', 'fcying@gmail.com')
endif

if (FindPlug('gen_clang_conf.vim') != -1)
  " compile_flags.txt, .ccls
  let g:gen_clang_conf#clang_conf_name = get(g:, 'gen_clang_conf#clang_conf_name', '.ccls')
endif

"}}}
