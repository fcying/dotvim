" ncm2 asyncomplete coc ycm completor
let g:complete_func = get(g:, 'complete_func', 'coc')

" for spacevim plugin
let g:spacevim_data_dir = g:config_dir . '/.cache/spacevim'


" ============================================================================
" plugin {{{
" ============================================================================
let g:plug_dir = g:config_dir . '/plugged'
if filereadable(expand(g:plug_dir . '/vim-plug/plug.vim')) == 0
  if executable('git')
    if filereadable(expand(g:file_vimrc_local)) == 0
      call writefile([
            \ 'let g:complete_func=''ncm2''',
            \ '"let g:colorscheme=''solarized8''',
            \ '"let g:background=''light''',
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
Plug 'wsdjeg/vim-fetch'
Plug 'tpope/vim-eunuch'
Plug 'moll/vim-bbye', {'on':'Bdelete'}
Plug 'itchyny/lightline.vim'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-apathy'
Plug 'chrisbra/Colorizer'
"Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }

Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 't9md/vim-choosewin', {'on':'<Plug>(choosewin)'}
Plug 'scrooloose/nerdtree', {'on':['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind']}
"Plug 'justinmk/vim-dirvish'
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar', {'on':'TagbarToggle'}
"Plug 'Krasjet/auto.pairs'

Plug 'aperezdc/vim-template', {'on':'TemplateHere'}
Plug 'Vimjas/vim-python-pep8-indent', {'for':'python'}
Plug 'cespare/vim-toml'
Plug 'peterhoeg/vim-qml'
Plug 'neoclide/jsonc.vim'
"Plug 'ekalinin/Dockerfile.vim'
Plug 'wsdjeg/vim-autohotkey', {'for':'autohotkey'}
Plug 'plasticboy/vim-markdown', {'for':'markdown'}

Plug 'easymotion/vim-easymotion'
Plug 'dyng/ctrlsf.vim'
if exists('*popup_menu') || g:is_nvim
  Plug 'pechorin/any-jump.vim'
endif
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
Plug 'brooth/far.vim'
Plug 'wsdjeg/FlyGrep.vim'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

Plug 'dstein64/vim-startuptime', {'on':'StartupTime'}
Plug 'MattesGroeger/vim-bookmarks'
Plug 'thinca/vim-ref'
Plug 'derekwyatt/vim-fswitch'
Plug 'nathanaelkane/vim-indent-guides', {'on':'<Plug>IndentGuidesToggle'}
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
"Plug 'lambdalisue/gina.vim', {'on': 'Gina'}
Plug 'tpope/vim-fugitive'

Plug 'skywind3000/vim-preview'
Plug 'skywind3000/asyncrun.vim'
Plug 'fcying/gen_clang_conf.vim'
Plug 'mattn/emmet-vim'
Plug 'honza/vim-snippets'
"Plug 'w0rp/ale'

" color
Plug 'tomasr/molokai'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'

" complete_func
function! UpdateLsp() abort
  "silent !rustup update
  "silent !rustup component add rls rust-analysis rust-src
  "silent !npm install -g typescript typescript-language-server
  "silent !npm install -g dockerfile-language-server-nodejs
  silent !pip3 install python-language-server --upgrade
  silent !pip3 install jedi pylint --upgrade
  silent !mkdir -p ~/.npm
  silent !cd ~/.npm; npm install dockerfile-language-server-nodejs
  if g:has_go
    GoGetTools
  endif
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
  Plug 'prabirshrestha/vim-lsp', {'do': function('UpdateLsp')}
  Plug 'mattn/vim-lsp-settings'
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-gtags'
  Plug 'yuki-ycino/ncm2-dictionary'
  Plug 'ncm2/ncm2-cssomni'
  Plug 'ncm2/ncm2-html-subscope'
  Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
  "Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
  Plug 'ncm2/ncm2-ultisnips' | Plug 'SirVer/ultisnips'
elseif g:complete_func ==# 'coc'
  function! InstallCoc(info) abort
    if a:info.status !=# 'unchanged' || a:info.force
      call UpdateLsp()
    endif
  endfunction
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': function('InstallCoc')}
elseif g:complete_func ==# 'asyncomplete'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp', {'do': function('UpdateLsp')}
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
elseif g:complete_func ==# 'ycm'
  Plug 'ycm-core/YouCompleteMe'
elseif g:complete_func ==# 'completor'
  Plug 'maralla/completor.vim'
  Plug 'kyouryuukunn/completor-necovim'
  Plug 'masawada/completor-dictionary'
  Plug 'SirVer/ultisnips'
  Plug 'maralla/completor-neosnippet'
  "Plug 'ferreum/completor-tmux'  "let other complete error
endif

call plug#end()
delc PlugUpgrade

nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>



" ============================================================================
" plugin settings {{{
" ============================================================================
" gen tags
nnoremap <silent> <leader>tg :GenClangConf<CR>:Leaderf gtags --update<CR>
nnoremap <silent> <leader>tr :ClearClangConf<CR>:Leaderf gtags --remove<CR>y<CR>

if (FindPlug('vim-indent-guides') != -1) "{{{
  let g:indent_guides_enable_on_vim_startup=0
  let g:indent_guides_start_level=2
  let g:indent_guides_guide_size=1
  :nmap <silent> <Leader>i <Plug>IndentGuidesToggle
endif "}}}

if (FindPlug('asyncrun.vim') != -1) "{{{
  let g:asyncrun_bell = 1
  let g:asyncrun_silent = get(g:, 'asyncrun_silent', '0')
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
endif "}}}

if (FindPlug('vim-preview') != -1) "{{{
  autocmd myau FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  autocmd myau FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
endif "}}}

if (FindPlug('lightline.vim') != -1) "{{{
  set showtabline=1
  let g:lightline = {}
  let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }
endif "}}}

if (FindPlug('vim-expand-region') != -1) "{{{
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
endif "}}}

if (FindPlug('gina.vim') != -1) "{{{
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
endif "}}}

if (FindPlug('vim-fugitive') != -1) "{{{
  autocmd myau FileType fugitive* nmap <buffer> q gq
endif "}}}

if (FindPlug('LanguageClient-neovim') != -1) "{{{
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

endif "}}}

if (FindPlug('vim-lsp') != -1) "{{{
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
endif "}}}

if (FindPlug('vim-lsp-settings') != -1) "{{{
  let g:lsp_settings_servers_dir = g:cache_dir . '/lsp_settings'
  let g:lsp_settings_root_markers = ['.root/', '.git', '.git/', '.svn/']
  let g:lsp_settings_filetype_python = ['pyls-ms', 'pyls']
endif "}}}


if (FindPlug('ale') != -1) "{{{
  nmap <silent> <leader>aj :ALENext<cr>
  nmap <silent> <leader>ak :ALEPrevious<cr>

  let g:ale_sh_shellcheck_exclusions = 'SC2164,SC2086,SC1090'

  let g:ale_linters = {
        \   'c': [],
        \}
endif "}}}

if (FindPlug('ultisnips') != -1) "{{{
  "let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
  let g:UltiSnipsRemoveSelectModeMappings = 0
endif "}}}

if (FindPlug('asyncomplete.vim') != -1) "{{{
  let g:asyncomplete_remove_duplicates = 1

  "let g:lsp_log_verbose = 1
  "let g:lsp_log_file = expand('/tmp/vim-lsp.log')
  "let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')

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

if (FindPlug('coc.nvim') != -1) "{{{
  let g:coc_data_home = g:cache_dir . '/coc'
  let $NVIM_COC_LOG_FILE=g:coc_data_home . '/log'
  let g:coc_config_home = g:config_dir
  "'coc-pairs', 'coc-syntax'
  let g:coc_global_extensions = ['coc-vimlsp',
        \ 'coc-dictionary', 'coc-syntax',
        \ 'coc-rls', 'coc-go',
        \ 'coc-clangd', 'coc-cmake',
        \ 'coc-yaml', 'coc-xml', 'coc-json',
        \ 'coc-css', 'coc-html',
        \ 'coc-tsserver'
        \ ]
  call add(g:coc_global_extensions, 'coc-snippets')
  "call add(g:coc_global_extensions, 'coc-python')
  call add(g:coc_global_extensions, 'coc-pyright')
  "call add(g:coc_global_extensions, 'coc-java')

  "if exists('*complete_info')
  "  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  "else
  "  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  "endif

  inoremap <silent><expr> <c-l> coc#refresh()
  inoremap <silent> <c-h> <c-o><Plug>(coc-float-hide)

  " snippets
  imap <c-j> <Plug>(coc-snippets-expand)
  let g:coc_snippet_next = '<c-j>'
  let g:coc_snippet_prev = '<c-k>'

  " pairs
  "autocmd myau FileType markdown let b:coc_pairs_disabled = ['`']
  "autocmd myau FileType vim let b:coc_pairs_disabled = ['"']

  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  nmap <leader>rf <Plug>(coc-refactor)
  nmap <leader>rn <Plug>(coc-rename)

  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  if !exists('g:lightline')
    let g:lightline = {}
  endif
  let g:lightline.active ={
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
        \ }
  let g:lightline.component_function ={
        \   'cocstatus': 'coc#status'
        \ }
endif "}}}

if (FindPlug('ncm2') != -1) "{{{
  "let $NVIM_PYTHON_LOG_FILE="/tmp/ncm2_log"
  "let $NVIM_NCM_LOG_LEVEL="DEBUG"
  "let $NVIM_NCM_MULTI_THREAD=0

  " note that must keep noinsert in completeopt, the others is optional
  let g:ncm2#complete_length = [[1,2],[7,1]]

  "autocmd myau BufEnter * call ncm2#enable_for_buffer()
  autocmd myau InsertEnter * call ncm2#enable_for_buffer()

  let g:ncm2#matcher = 'substrfuzzy'
  "let g:ncm2#sorter = 'abbrfuzzy'
endif "}}}

if (FindPlug('YouCompleteMe') != -1) "{{{
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_add_preview_to_completeopt = 0

  let g:ycm_show_diagnostics_ui = 0
  let g:ycm_server_log_level = 'info'
  let g:ycm_min_num_identifier_candidate_chars = 2
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_strings=1
  let g:ycm_key_invoke_completion = '<c-z>'

  let g:ycm_semantic_triggers =  {
        \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
        \ 'cs,lua,javascript': ['re!\w{2}'],
        \ }

let g:ycm_filetype_whitelist = {
			\ 'c':1, 'cpp':1, 'objc':1, 'objcpp':1,
			\ 'go':1, 'rust':1, 'python':1, 'vim':1,
			\ 'lua':1, 'java':1, 'ruby':1, 'php':1,
			\ 'javascript':1, 'typedscript':1, 'coffee':1,
			\ 'perl':1, 'perl6':1, 'erlang':1,
			\ 'asm':1, 'nasm':1, 'masm':1, 'tasm':1, 'asm68k':1, 'asmh8300':1,
			\ 'basic':1, 'cs':1, 'vb':1,
			\ 'make':1, 'cmake':1,
			\ 'html':1, 'css':1, 'less':1,
			\ 'dosini':1, 'conf':1, 'config':1, 'json':1, 'cson':1,
			\ 'haskell':1, 'lhaskell':1, 'lisp':1,
			\ 'scheme':1, 'sdl':1,
			\ 'sh':1, 'zsh':1, 'bash':1, 'ps1':1, 'bat':1,
			\ 'asciidoc':1, 'man':1, 'markdown':1, 'matlab':1, 'maxima':1,
			\ }
endif "}}}

if (FindPlug('completor.vim') != -1) "{{{
  let g:completor_auto_trigger = 1
  let g:completor_complete_options = 'menuone,noselect,preview'
  let g:completor_clang_disable_placeholders = 1
  let g:completor_min_chars = 1
  noremap <silent> gd :call completor#do('definition')<CR>
  noremap <silent> gc :call completor#do('doc')<CR>
  noremap <silent> gf :call completor#do('format')<CR>
  noremap <silent> gs :call completor#do('hover')<CR>
  let g:completor_filetype_map = {}
  let g:completor_filetype_map.go = {'ft': 'lsp', 'cmd': 'gopls'}
  let g:completor_filetype_map.c = {'ft': 'lsp', 'cmd': 'clangd'}
  let g:completor_filetype_map.rust = {'ft': 'lsp', 'cmd': 'rls'}
endif "}}}

if (FindPlug('vim-visual-multi') != -1) "{{{
  let g:VM_no_meta_mappings = 1
  let g:VM_maps = {}
  let g:VM_maps['Find Under']         = '<C-n>'
  let g:VM_maps['Find Subword Under'] = '<C-n>'
  let g:VM_cmdheight = 1
  "let g:VM_manual_infoline = 1
endif "}}}

if (FindPlug('nerdtree') != -1) "{{{
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
endif "}}}

if (FindPlug('vim-dirvish') != -1) "{{{
  let g:dirvish_mode = 1
  let g:dirvish_relative_paths = 0
endif "}}}

if (FindPlug('ctrlsf.vim') != -1) "{{{
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
endif "}}}

if (FindPlug('vim-session') != -1) "{{{
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
  let g:session_directory = g:cache_dir . '/sessions'
endif "}}}

if (FindPlug('FlyGrep.vim') != -1) "{{{
  nnoremap f/ :<C-u>FlyGrep<cr>
endif "}}}

if (FindPlug('far.vim') != -1) "{{{
  let g:far#enable_undo = 1
  let g:far#source = 'rg'
  let g:far#ignore_files = [g:etc_dir . '/farignore']
endif "}}}

if (FindPlug('LeaderF') != -1) "{{{
  let g:Lf_ShowDevIcons = 0
  let g:Lf_ShowHidden = 1
  let g:Lf_HideHelp = 1
  let g:Lf_DefaultMode = 'FullPath'
  let g:Lf_UseCache = 0
  let g:Lf_PreviewCode = 0
  let g:Lf_WorkingDirectoryMode = 'c'
  let g:Lf_UseVersionControlTool = 0
  let g:Lf_JumpToExistingWindow = 0
  let g:Lf_CacheDirectory = g:cache_dir
  let g:Lf_RootMarkers = ['.root', '.git', '.svn']
  if g:is_win ==# 0
    let g:Lf_Ctags = 'ctags 2>/dev/null'
  endif
  let g:Lf_GtagsAutoGenerate = 0
  let g:Lf_GtagsSource = 2
  let g:Lf_GtagsStoreInRootMarker = 1
  "let g:Lf_GtagsStoreInProject = 1
  "let $GTAGSLABEL = 'native-pygments'
  "let $GTAGSCONF = g:etc_dir . '/gtags.conf'
  "let g:Lf_Gtagslabel = 'native-pygments'
  let g:Lf_Gtagslabel = 'ctags'
  let g:Lf_Gtagsconf = get(g:, 'Lf_Gtagsconf', g:etc_dir . '/gtags.conf')

  let g:Lf_PreviewInPopup = 1
  "let g:Lf_WindowPosition = 'popup'
  "let g:Lf_PreviewHorizontalPosition = 'right'

  let g:Lf_CommandMap = {'<F5>': ['<C-L>']}
  let g:Lf_NormalMap = {
        \ '_':        [['<C-j>', 'j'],
        \              ['<C-k>', 'k'],
        \             ],
        \ 'File':     [['<ESC>', ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
        \ 'Buffer':   [['<ESC>', ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
        \ 'BufTag':   [['<ESC>', ':exec g:Lf_py "bufTagExplManager.quit()"<CR>']],
        \ 'Mru':      [['<ESC>', ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
        \ 'Line':     [['<ESC>', ':exec g:Lf_py "lineExplManager.quit()"<CR>']],
        \ 'Function': [['<ESC>', ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
        \ 'Tag':      [['<ESC>', ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
        \ 'Rg':       [['<ESC>', ':exec g:Lf_py "rgExplManager.quit()"<CR>']],
        \ 'Gtags':    [['<ESC>', ':exec g:Lf_py "gtagsExplManager.quit()"<CR>']],
        \ }

  let g:Lf_PreviewResult = {
        \ 'File': 0,
        \ 'Buffer': 0,
        \ 'Mru': 0,
        \ 'Tag': 0,
        \ 'BufTag': 0,
        \ 'Function': 0,
        \ 'Line': 0,
        \ 'Colorscheme': 0,
        \ 'Rg': 0,
        \ 'Gtags': 0
        \}

  if !exists('g:Lf_MruFileExclude')
    let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
  endif

  if !exists('g:Lf_WildIgnore')
    let g:Lf_WildIgnore = {
          \ 'dir': ['.root','.svn','.git','.hg','.ccls-cache'],
          \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
          \}
  endif

  if !exists('g:Lf_RgConfig')
    let g:Lf_RgConfig = [
          \ '--max-columns=300',
          \ '--glob=!.git',
          \ '--glob=!.svn',
          \ '--glob=!.hg',
          \ '--glob=!.repo',
          \ '--glob=!.root',
          \ '--glob=!.ccache',
          \ '--glob=!.cache',
          \ '--glob=!.ccls-cache',
          \ '--glob=!GTAGS',
          \ '--glob=!GRTAGS',
          \ '--glob=!GPATH',
          \ '--glob=!tags',
          \ '--glob=!.pyc',
          \ '--glob=!.tmp',
          \ '--glob=!.swp',
          \ '--iglob=!obj',
          \ '--iglob=!out',
          \ '--hidden'
          \ ]
  endif

  nnoremap ff :<C-u>Leaderf file --fullPath<CR>
  nnoremap fb :<C-u>Leaderf buffer --fullPath<CR>
  nnoremap fo :<C-u>Leaderf function --fullPath<CR>
  nnoremap fm :<C-u>Leaderf mru --fullPath<CR>
  nnoremap fl :<C-u>Leaderf line --regex<CR>
  nnoremap ft :<C-u>Leaderf gtags --fuzzy<CR>
  nnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w %s", expand("<cword>"))<CR>
  nnoremap fG :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w ")<CR>
  xnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w -F %s", leaderf#Rg#visual())<CR>
  nnoremap fs :<C-u>CtrlSF
  nnoremap fr :<C-U>Leaderf --recall<CR><TAB>

  nnoremap fi :exec "Leaderf file --fullPath --input " . <SID>strip_include(getline("."))<CR>
  function! s:strip_include(line)
    let l:strip_include = substitute(a:line, '\v.*[\<"]([a-zA-Z0-9_/\.]+)[\>"]', '\1', 'g')
    return l:strip_include
  endfunction
  nnoremap fh :exec "Leaderf file --input " . <SID>fswitch()<CR>
  function! s:fswitch()
    let l:filename = expand('%:t:r')
    let l:extension = expand('%:e')
    if l:extension ==# 'h'
      return l:filename . '.c' . ' --fullPath'
    elseif l:extension ==# 'c' || l:extension ==# 'cpp'
      return l:filename . '.h' . ' --fullPath'
    endif
  endfunction

  "noremap <C-]> :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap tr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap td :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
  "noremap to :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
  noremap tn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
  noremap tp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
endif "}}}

if (FindPlug('vim-choosewin') != -1) "{{{
  nmap - <Plug>(choosewin)
endif "}}}

if (FindPlug('vim-bookmarks') != -1) "{{{
  nmap <Leader>m <Plug>BookmarkToggle
  nmap <Leader>mi <Plug>BookmarkAnnotate
  nmap <Leader>ma <Plug>BookmarkShowAll
  nmap <Leader>mj <Plug>BookmarkNext
  nmap <Leader>mk <Plug>BookmarkPrev
  nmap <Leader>mc <Plug>BookmarkClear
  nmap <Leader>mx <Plug>BookmarkClearAll
endif "}}}

if (FindPlug('vim-ref') != -1) "{{{
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
endif "}}}

if (FindPlug('fencview') != -1) "{{{
  let g:fencview_autodetect = 1
  let g:fencview_checklines = 10
endif "}}}

if (FindPlug('nerdcommenter') != -1) "{{{
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
        \ 'jsonc': { 'left': '//' },
        \ 'rc': { 'left': '#' },
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
endif "}}}

if (FindPlug('tagbar') != -1) "{{{
  nnoremap <silent><Leader>tt :TagbarToggle<CR>
  nnoremap <silent><F11> :TagbarToggle<CR>
  let g:tagbar_left=1
  let g:tagbar_width=32
  let g:tagbar_compact=1
  let g:tagbar_type_vim = {
        \ 'ctagstype' : 'vim',
        \ 'kinds' : [
        \ 'p:plugin_setting',
        \ 'f:functions',
        \ ]
        \ }
  let g:tagbar_type_sh = {
        \ 'ctagstype' : 'sh',
        \ 'kinds' : [
        \ 'i:if_condition',
        \ 'f:functions',
        \ ]
        \ }
endif "}}}

if (FindPlug('vim-bbye') != -1) "{{{
  :nnoremap <Leader>q :Bdelete<CR>
endif "}}}

if (FindPlug('vim-easymotion') != -1) "{{{
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
endif "}}}

if (FindPlug('vim-fswitch') != -1) "{{{
  nnoremap <silent> <Leader>h <ESC>:FSHere<CR>
endif "}}}

if (FindPlug('emmet-vim') != -1) "{{{
  let g:user_emmet_install_global = 0
  autocmd myau FileType html,css EmmetInstall
endif "}}}

if (FindPlug('vim-template') != -1) "{{{
  nnoremap <silent> <Leader>th :TemplateHere<CR>
  nnoremap <silent> <Leader>tf :execute 'Template *.' . &filetype<CR>
  let g:templates_no_autocmd = 1
  exe 'let g:templates_directory = [''' . g:etc_dir . '/template'']'
  let g:user = get(g:, 'user', 'fcying')
  let g:email = get(g:, 'email', 'fcying@gmail.com')
endif "}}}

if (FindPlug('any-jump.vim') != -1) "{{{
  let g:any_jump_disable_default_keybindings = 0
endif "}}}

if (FindPlug('gen_clang_conf.vim') != -1) "{{{
  " compile_flags.txt, .ccls
  let g:gen_clang_conf#clang_conf_name = get(g:, 'gen_clang_conf#clang_conf_name', 'compile_flags.txt')

  if !exists('g:gen_clang_conf#ignore_dirs')
    let g:gen_clang_conf#ignore_dirs = ['__pycache__', 'out', 'lib', 'build',
          \ 'cache', 'doc', 'docs']
  endif
endif "}}}

if (FindPlug('auto.pairs') != -1) "{{{
  autocmd myau FileType markdown let b:AutoPairsSingleQuoteBalanceCheck = 0
endif "}}}

if (FindPlug('Colorizer') != -1) "{{{
  nnoremap <silent> <leader>ch :call <SID>set_color_highlight()<CR>
  function! s:set_color_highlight()
    ColorHighlight!
    au myau BufRead <buffer> :ColorHighlight!<CR>
  endfunction
endif "}}}

if (FindPlug('vim-hexokinase') != -1) "{{{
  "let g:Hexokinase_ftEnabled = []
  let g:Hexokinase_termDisabled = 1
  let g:Hexokinase_highlighters = ['backgroundfull']
  let g:Hexokinase_refreshEvents = ['BufWrite', 'BufRead', 'TextChanged', 'InsertLeave']
  let g:Hexokinase_palettes = [g:etc_dir . '/hexokinase.json']
  nnoremap <silent> <leader>ch :HexokinaseTurnOn<CR>
endif "}}}

"}}}


" auto update pvimrc var
if !exists('g:custom_ignore')
  let g:custom_ignore = {
        \ 'dir': [],
        \ 'file': [],
        \}
endif
let g:b_Lf_MruFileExclude = deepcopy(g:Lf_MruFileExclude)
let g:b_Lf_WildIgnore = deepcopy(g:Lf_WildIgnore)
let g:b_Lf_RgConfig = deepcopy(g:Lf_RgConfig)
let g:b_gen_clang_conf#ignore_dirs = deepcopy(g:gen_clang_conf#ignore_dirs)

function! s:update_ignore()
  let g:Lf_MruFileExclude = deepcopy(g:b_Lf_MruFileExclude)
  let g:Lf_WildIgnore = deepcopy(g:b_Lf_WildIgnore)
  let g:Lf_RgConfig = deepcopy(g:b_Lf_RgConfig)
  let g:gen_clang_conf#ignore_dirs = deepcopy(g:b_gen_clang_conf#ignore_dirs)
  for i in g:custom_ignore['file']
    call add(g:Lf_MruFileExclude, i)
    call add(g:Lf_WildIgnore['file'], i)
    call add(g:Lf_RgConfig, '--glob=!' . i)
  endfor
  for i in g:custom_ignore['dir']
    call add(g:Lf_WildIgnore['dir'], i)
    call add(g:Lf_RgConfig, '--glob=!' . i)
    call add(g:gen_clang_conf#ignore_dirs, i)
  endfor

  let l:cmd=''
  for i in g:Lf_RgConfig
    let l:cmd = l:cmd . i . ' '
  endfor
  let g:Lf_GtagsfilesCmd = {
        \ '.git': 'rg --no-messages --files ' . l:cmd,
        \ '.hg': 'rg --no-messages --files ' . l:cmd,
        \ 'default': 'rg --no-messages --files ' . l:cmd
        \}
endfunction
au myau SourcePost .pvimrc call s:update_ignore()
call s:update_ignore()
