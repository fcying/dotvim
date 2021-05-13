" ncm2 asyncomplete coc ycm vap
let g:complete_func = get(g:, 'complete_func', 'coc')

" for spacevim plugin
let g:spacevim_data_dir = g:config_dir . '/.cache/spacevim'


" ============================================================================
" plugin init {{{
" ============================================================================
let g:plug_dir = g:config_dir . '/.plugged'
if filereadable(expand(g:plug_dir . '/vim-plug/plug.vim')) == 0
  if executable('git')
    if filereadable(expand(g:file_vimrc_local)) == 0
      call writefile([
            \ 'let g:complete_func=''coc''',
            \ '"let g:colorscheme=''solarized8''',
            \ '"let g:background=''light''',
            \ 'function! LoadAfter()',
            \ 'endfunc',
            \ ], expand(g:file_vimrc_local), 'a')
    endif
    call mkdir(g:plug_dir, 'p')
    exec 'silent !git clone --depth 1 https://github.com/junegunn/vim-plug '
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
"Plug 'tpope/vim-eunuch'
Plug 'lambdalisue/suda.vim'
Plug 'moll/vim-bbye', {'on':'Bdelete'}
Plug 'itchyny/lightline.vim'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-apathy'
Plug 'chrisbra/Colorizer'
"Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'skywind3000/vim-quickui'
Plug 'liuchengxu/vim-which-key'
"Plug 'roxma/vim-paste-easy'

" FIXME
if g:is_nvim
  Plug 'antoinemadec/FixCursorHold.nvim'
endif

Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 't9md/vim-choosewin', {'on':'<Plug>(choosewin)'}
"Plug 'preservim/nerdtree', {'on':['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind']}
Plug 'lambdalisue/fern.vim'
Plug 'preservim/nerdcommenter'
Plug 'preservim/tagbar', {'on':'TagbarToggle'}
"Plug 'Krasjet/auto.pairs'
Plug 'andymass/vim-matchup'
Plug 'fcying/vim-foldsearch'

Plug 'aperezdc/vim-template', {'on':'TemplateHere'}
Plug 'Vimjas/vim-python-pep8-indent', {'for':'python'}
Plug 'cespare/vim-toml'
Plug 'peterhoeg/vim-qml'
Plug 'neoclide/jsonc.vim'
Plug 'wsdjeg/vim-autohotkey', {'for':'autohotkey'}

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', {'for':'markdown'}

Plug 'easymotion/vim-easymotion'
"Plug 'justinmk/vim-sneak'
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

Plug 'dstein64/vim-startuptime', {'on':'StartupTime'}
Plug 'MattesGroeger/vim-bookmarks'
Plug 'thinca/vim-ref'
Plug 'derekwyatt/vim-fswitch'
Plug 'Yggdroot/indentLine' ", {'on':'IndentLinesToggle'}
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'tpope/vim-fugitive'

Plug 'skywind3000/vim-preview'
Plug 'skywind3000/asyncrun.vim', {'on': ['AsyncRun', 'AsyncStop'] }
Plug 'skywind3000/asynctasks.vim', {'on': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }

Plug 'fcying/gen_clang_conf.vim'
Plug 'mattn/emmet-vim'
Plug 'honza/vim-snippets'
"Plug 'w0rp/ale'

if g:is_nvim ==# 0
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'roxma/vim-tmux-clipboard'
endif

" color {{{
Plug 'tomasr/molokai'
Plug 'lifepillar/vim-solarized8'
Plug 'lifepillar/vim-gruvbox8'

" complete_func
function! UpdateLsp() abort
  "silent !rustup update
  "silent !rustup component add rls rust-analysis rust-src
  silent !pip3 install python-language-server --upgrade
  silent !pip3 install jedi pylint --upgrade
  call mkdir($HOME . '/.npm', 'p')
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
  Plug 'prabirshrestha/asyncomplete-tags.vim'
  Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
  Plug 'prabirshrestha/asyncomplete-necovim.vim'
elseif g:complete_func ==# 'ycm'
  Plug 'ycm-core/YouCompleteMe', {'do': 'python3 install.py --all'}
elseif g:complete_func ==# 'vap'
  Plug 'skywind3000/vim-auto-popmenu', {'do': 'python3 install.py --all'}
endif

if g:is_win ==# 0
  Plug 'wellle/tmux-complete.vim'
endif

call plug#end()
delc PlugUpgrade

nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>



" ============================================================================
" plugin settings
" ============================================================================
" gen tags {{{
nnoremap <silent> <leader>tg :GenClangConf<CR>:Leaderf gtags --update<CR>
nnoremap <silent> <leader>tr :ClearClangConf<CR>:Leaderf gtags --remove<CR>y<CR>

if (HasPlug('indentLine') != -1) "{{{
  let g:indentLine_setColors = 1
  let g:indentLine_enabled = 0
  let g:indentLine_char_list = ['|', '¦', '┆', '┊']
  nmap <silent> <Leader>i :IndentLinesToggle<CR>
endif "}}}

if (HasPlug('asyncrun.vim') != -1) "{{{
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
      silent cnext
    endif
  endfunction
endif "}}}

if (HasPlug('asynctasks.vim') != -1) "{{{
  let g:asyncrun_rootmarks = ['.root', '.git', '.svn']
  let g:asynctasks_config_name = ['.root/.tasks', '.git/.tasks', '.tasks']
  let g:asynctasks_rtp_config = "asynctasks.ini"
  nnoremap <leader>b :AsyncTask build<CR>
endif

if (HasPlug('vim-preview') != -1) "{{{
  autocmd myau FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  autocmd myau FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
endif "}}}

if (HasPlug('lightline.vim') != -1) "{{{
  set showtabline=1
  let g:lightline = {}
  let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }
endif "}}}

if (HasPlug('FixCursorHold.nvim') != -1) "{{{
  let g:cursorhold_updatetime = 300
endif "}}}

if (HasPlug('vim-expand-region') != -1) "{{{
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

if (HasPlug('vim-fugitive') != -1) "{{{
  autocmd myau FileType fugitive* nmap <buffer> q gq
endif "}}}

if (HasPlug('LanguageClient-neovim') != -1) "{{{
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

if (HasPlug('vim-lsp') != -1) "{{{
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

if (HasPlug('vim-lsp-settings') != -1) "{{{
  let g:lsp_settings_servers_dir = g:cache_dir . '/lsp_settings'
  let g:lsp_settings_root_markers = ['.root/', '.git', '.git/', '.svn/']
  let g:lsp_settings_filetype_python = ['pyls-ms', 'pyls']
endif "}}}


if (HasPlug('ale') != -1) "{{{
  nmap <silent> <leader>aj :ALENext<cr>
  nmap <silent> <leader>ak :ALEPrevious<cr>

  let g:ale_sh_shellcheck_exclusions = 'SC2164,SC2086,SC1090'

  let g:ale_linters = {
        \   'c': [],
        \}
endif "}}}

if (HasPlug('ultisnips') != -1) "{{{
  "let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
  let g:UltiSnipsRemoveSelectModeMappings = 0
endif "}}}

if (HasPlug('asyncomplete.vim') != -1) "{{{
  let g:asyncomplete_remove_duplicates = 1

  "let g:lsp_log_verbose = 1
  "let g:lsp_log_file = expand('/tmp/vim-lsp.log')
  "let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')

  if (HasPlug('asyncomplete-buffer.vim') != -1)
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
  if (HasPlug('asyncomplete-file.vim') != -1)
    au myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
          \ 'name': 'file',
          \ 'whitelist': ['*'],
          \ 'priority': 10,
          \ 'completor': function('asyncomplete#sources#file#completor')
          \ }))
  endif
  if (HasPlug('asyncomplete-neoinclude.vim') != -1)
    au myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neoinclude#get_source_options({
          \ 'name': 'neoinclude',
          \ 'whitelist': ['cpp'],
          \ 'refresh_pattern': '\(<\|"\|/\)$',
          \ 'completor': function('asyncomplete#sources#neoinclude#completor'),
          \ }))
  endif
  if (HasPlug('asyncomplete-omni.vim') != -1)
    call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
          \ 'name': 'omni',
          \ 'whitelist': ['*'],
          \ 'blacklist': ['c', 'cpp', 'html'],
          \ 'completor': function('asyncomplete#sources#omni#completor')
          \  }))
  endif
  if (HasPlug('asyncomplete-tags.vim') != -1)
    au myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
          \ 'name': 'tags',
          \ 'whitelist': ['c'],
          \ 'completor': function('asyncomplete#sources#tags#completor'),
          \ 'config': {
          \    'max_file_size': 50000000,
          \  },
          \ }))
  endif
  if (HasPlug('asyncomplete-necosyntax.vim') != -1)
    autocmd myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
          \ 'name': 'necosyntax',
          \ 'whitelist': ['*'],
          \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
          \ }))
  endif
  if (HasPlug('asyncomplete-necovim.vim') != -1)
    autocmd myau User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
          \ 'name': 'necovim',
          \ 'whitelist': ['vim'],
          \ 'completor': function('asyncomplete#sources#necovim#completor'),
          \ }))
  endif
endif "}}}

if (HasPlug('coc.nvim') != -1) "{{{
  let g:coc_data_home = g:cache_dir . '/coc'
  let $NVIM_COC_LOG_FILE=g:coc_data_home . '/log'
  let g:coc_config_home = g:config_dir
  "'coc-pairs', 'coc-syntax'
  let g:coc_global_extensions = ['coc-vimlsp',
        \ 'coc-dictionary', 'coc-syntax',
        \ 'coc-rls', 'coc-go', 'coc-lua',
        \ 'coc-clangd', 'coc-cmake',
        \ 'coc-yaml', 'coc-toml', 'coc-xml', 'coc-json',
        \ 'coc-css', 'coc-html',
        \ 'coc-tsserver', 'coc-docker',
        \ 'coc-marketplace'
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

  " switch source header
  autocmd myau FileType c,cpp nnoremap <silent> <buffer> <Leader>h <ESC>:CocCommand clangd.switchSourceHeader<CR>

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

if (HasPlug('ncm2') != -1) "{{{
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

if (HasPlug('vim-auto-popmenu') != -1) "{{{
  let g:apc_enable_ft = {'*':1}
  set completeopt=menu,menuone,noselect
  set shortmess+=c
endif "}}}

if (HasPlug('YouCompleteMe') != -1) "{{{
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_add_preview_to_completeopt = 0

  let g:ycm_show_diagnostics_ui = 0
  let g:ycm_server_log_level = 'info'
  let g:ycm_min_num_identifier_candidate_chars = 2
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_complete_in_strings=1
  let g:ycm_key_invoke_completion = '<c-l>'

  let g:ycm_semantic_triggers =  {
        \ 'c,cpp': [ '->', '.', 're!\w{2}'],
        \ 'python,java,go,rust,lua': ['.', 're!\w{2}'],
        \ 'cs,javascript': ['re!\w{2}'],
        \ 'sh': ['re!\w{2}'],
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

if (HasPlug('tmux-complete.vim') != -1) "{{{
  let g:tmuxcomplete#trigger = 'omnifunc'
endif

if (HasPlug('vim-visual-multi') != -1) "{{{
  let g:VM_no_meta_mappings = 1
  let g:VM_maps = {}
  let g:VM_maps['Find Under']         = '<C-n>'
  let g:VM_maps['Find Subword Under'] = '<C-n>'
  let g:VM_cmdheight = 1
  "let g:VM_manual_infoline = 1
endif "}}}

if (HasPlug('nerdtree') != -1) "{{{
  nmap <leader>wf :NERDTreeToggle<cr>
  nmap <leader>wl :NERDTreeFind<cr>
  nmap <F12> :NERDTreeToggle<cr>
  let g:NERDTreeWinSize=32
  let g:NERDTreeWinPos='left'
  let g:NERDTreeShowHidden=1
  let g:NERDTreeMinimalUI=1
  let g:NERDTreeAutoDeleteBuffer=1
  let g:NERDTreeShowBookmarks=1
  let g:NERDTreeShowLineNumbers=1
  let g:NERDTreeShowHidden=1
endif "}}}

if (HasPlug('fern.vim') != -1) "{{{
  " can't open on right https://github.com/lambdalisue/fern.vim/issues/272
  nmap <leader>wf :Fern . -drawer -toggle -keep<CR>
  nmap <leader>wl :Fern . -drawer -reveal=%<CR>
  autocmd myau FileType fern call s:init_fern()
  function! s:init_fern()
    nmap <buffer><expr>
          \ <Plug>(fern-my-open-or-expand-or-collapse)
          \ fern#smart#leaf(
          \   "\<Plug>(fern-action-open)",
          \   "\<Plug>(fern-action-expand)",
          \   "\<Plug>(fern-action-collapse)",
          \ )
    nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-or-expand-or-collapse)
    nmap <buffer> <enter> <Plug>(fern-my-open-or-expand-or-collapse)
    nmap <buffer> t <Plug>(fern-action-open:tabedit)
    nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
    nmap <buffer> i <Plug>(fern-action-open:split)
    nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
    nmap <buffer> s <Plug>(fern-action-open:vsplit)
    nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p

    nmap <buffer> E <Plug>(fern-action-enter)
    nmap <buffer> u <Plug>(fern-action-leave)
    nmap <buffer> r <Plug>(fern-action-reload)
    nmap <buffer> q :<C-u>quit<CR>
  endfunction
endif "}}}

if (HasPlug('vim-session') != -1) "{{{
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
  let g:session_directory = g:cache_dir . '/sessions'
endif "}}}

if (HasPlug('far.vim') != -1) "{{{
  let g:far#enable_undo = 1
  let g:far#source = 'rg'
  let g:far#ignore_files = [g:etc_dir . '/farignore']
endif "}}}

if (HasPlug('LeaderF') != -1) "{{{
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
          \ '--glob=!.repo',
          \ '--glob=!.root',
          \ '--glob=!.ccache',
          \ '--glob=!.cache',
          \ '--glob=!.ccls-cache',
          \ '--glob=!.clangd',
          \ '--glob=!GTAGS',
          \ '--glob=!GRTAGS',
          \ '--glob=!GPATH',
          \ '--glob=!tags',
          \ '--glob=!.pyc',
          \ '--glob=!.tmp',
          \ '--glob=!.swp',
          \ '--iglob=!obj',
          \ '--iglob=!out'
          \ ]
  endif

  let g:Lf_ShortcutF = ''
  let g:Lf_ShortcutB = ''
  nnoremap ff :<C-u>Leaderf file --fullPath<CR>
  nnoremap fb :<C-u>Leaderf buffer --fullPath<CR>
  nnoremap fo :<C-u>Leaderf function --fullPath<CR>
  nnoremap fm :<C-u>Leaderf mru --fullPath<CR>
  nnoremap fl :<C-u>Leaderf line --fuzzy<CR>
  nnoremap ft :<C-u>Leaderf gtags --fuzzy<CR>
  nnoremap fhc :<C-u>Leaderf cmdHistory --fuzzy<CR>
  nnoremap fhs :<C-u>Leaderf searchHistory --fuzzy<CR>
  nnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w %s", expand("<cword>"))<CR>
  nnoremap fG :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w ")<CR>
  xnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w -F %s", leaderf#Rg#visual())<CR>
  nnoremap fr :<C-U>Leaderf --recall<CR><TAB>
  nnoremap f/ :<C-U>Leaderf rg<CR>

  nnoremap fi :exec "Leaderf file --fullPath --input " . <SID>strip_include(getline("."))<CR>
  function! s:strip_include(line)
    let l:strip_include = substitute(a:line, '\v.*[\<"]([a-zA-Z0-9_/\.]+)[\>"]', '\1', 'g')
    return l:strip_include
  endfunction

  "noremap <C-]> :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap tr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
  noremap td :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
  "noremap to :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
  noremap tn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
  noremap tp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
endif "}}}

if (HasPlug('vim-choosewin') != -1) "{{{
  nmap - <Plug>(choosewin)
endif "}}}

if (HasPlug('vim-bookmarks') != -1) "{{{
  nmap <Leader>mt <Plug>BookmarkToggle
  nmap <Leader>mi <Plug>BookmarkAnnotate
  nmap <Leader>ma <Plug>BookmarkShowAll
  nmap <Leader>mj <Plug>BookmarkNext
  nmap <Leader>mk <Plug>BookmarkPrev
  nmap <Leader>mc <Plug>BookmarkClear
  nmap <Leader>mx <Plug>BookmarkClearAll
endif "}}}

if (HasPlug('vim-ref') != -1) "{{{
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

if (HasPlug('fencview') != -1) "{{{
  let g:fencview_autodetect = 1
  let g:fencview_checklines = 10
endif "}}}

if (HasPlug('nerdcommenter') != -1) "{{{
  " set default delimiter
  set commentstring=#%s
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
        \ '*': { 'left': '#' },
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

if (HasPlug('vim-matchup') != -1) "{{{
  let g:loaded_matchit = 1
endif "}}}

if (HasPlug('vim-foldsearch') != -1) "{{{
  let g:foldsearch_disable_mappings = 1
  let g:foldsearch_highlight = 1

  nmap <Leader>fg :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
  xmap <Leader>fg :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
  map <Leader>fw :call foldsearch#foldsearch#FoldCword()<CR>
  map <Leader>fs :call foldsearch#foldsearch#FoldSearch()<CR>
  map <Leader>fS :call foldsearch#foldsearch#FoldSpell()<CR>
  map <Leader>fl :call foldsearch#foldsearch#FoldLast()<CR>
  map <Leader>fi :call foldsearch#foldsearch#FoldContextAdd(+1)<CR>
  map <Leader>fd :call foldsearch#foldsearch#FoldContextAdd(-1)<CR>
  map <Leader>fe :call foldsearch#foldsearch#FoldSearchEnd()<CR>
endif "}}}

if (HasPlug('tagbar') != -1) "{{{
  nnoremap <silent><Leader>wt :TagbarToggle<CR>
  nnoremap <silent><F11> :TagbarToggle<CR>
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

if (HasPlug('vim-bbye') != -1) "{{{
  :nnoremap <Leader>q :Bdelete<CR>
endif "}}}

if (HasPlug('vim-easymotion') != -1) "{{{
  let g:EasyMotion_smartcase = 0
  let g:EasyMotion_do_mapping = 0   " Disable default mappings
  " move to {char}
  nmap s <Plug>(easymotion-overwin-f)
  " move to {char}{char}
  nmap S <Plug>(easymotion-overwin-f2)
  " Move to line
  nmap L <Plug>(easymotion-overwin-line)
  " Move to word
  "nmap <Leader>w <Plug>(easymotion-overwin-w)
endif "}}}

if (HasPlug('vim-sneak') != -1) "{{{
  let g:sneak#label = 1
endif "}}}

if (HasPlug('vim-fswitch') != -1) "{{{
  if (HasPlug('coc.nvim') ==# -1)
    autocmd myau FileType c,cpp nnoremap <silent> <buffer> <Leader>h <ESC>:FSHere<CR>
  endif
endif "}}}

if (HasPlug('emmet-vim') != -1) "{{{
  let g:user_emmet_install_global = 0
  autocmd myau FileType html,css EmmetInstall
endif "}}}

if (HasPlug('vim-template') != -1) "{{{
  nnoremap <silent> <Leader>th :TemplateHere<CR>
  nnoremap <silent> <Leader>tf :execute 'Template *.' . &filetype<CR>
  let g:templates_no_autocmd = 1
  exe 'let g:templates_directory = [''' . g:etc_dir . '/template'']'
  let g:user = get(g:, 'user', 'fcying')
  let g:email = get(g:, 'email', 'fcying@gmail.com')
endif "}}}

if (HasPlug('any-jump.vim') != -1) "{{{
  let g:any_jump_disable_default_keybindings = 1
  nnoremap <leader>aj :AnyJump<CR>
  xnoremap <leader>aj :AnyJumpVisual<CR>
  nnoremap <leader>ab :AnyJumpBack<CR>
  nnoremap <leader>al :AnyJumpLastResults<CR>
endif "}}}

if (HasPlug('gen_clang_conf.vim') != -1) "{{{
  " compile_flags.txt, .ccls
  let g:gen_clang_conf#conf_name = get(g:, 'gen_clang_conf#conf_name', 'compile_flags.txt')

  if !exists('g:gen_clang_conf#ignore_dirs')
    let g:gen_clang_conf#ignore_dirs = ['__pycache__', 'out', 'lib', 'build',
          \ 'cache', 'doc', 'docs']
  endif
endif "}}}

if (HasPlug('preview-markdown.vim') != -1) "{{{
  let g:preview_markdown_vertical=1
  let g:preview_markdown_auto_update=1
endif "}}}

if (HasPlug('suda.vim') != -1) "{{{
  command! -nargs=0 SudoWrite exec 'SudaWrite'
  command! -nargs=0 SudoRead exec 'SudaRead'
endif "}}}

if (HasPlug('Colorizer') != -1) "{{{
  nnoremap <silent> <leader>ch :call <SID>set_color_highlight()<CR>
  function! s:set_color_highlight()
    ColorHighlight!
    au myau BufRead <buffer> :ColorHighlight!<CR>
  endfunction
endif "}}}

if (HasPlug('vim-hexokinase') != -1) "{{{
  "let g:Hexokinase_ftEnabled = []
  let g:Hexokinase_termDisabled = 1
  let g:Hexokinase_highlighters = ['backgroundfull']
  let g:Hexokinase_refreshEvents = ['BufWrite', 'BufRead', 'TextChanged', 'InsertLeave']
  let g:Hexokinase_palettes = [g:etc_dir . '/hexokinase.json']
  nnoremap <silent> <leader>ch :HexokinaseTurnOn<CR>
endif "}}}

if (HasPlug('vim-which-key') != -1) "{{{
  set timeoutlen=500
  silent! call which_key#register('<Space>', "g:which_key_map")
  nnoremap <silent> <leader> :<c-u>WhichKey '<leader>'<CR>
  silent! call which_key#register('f', "g:which_key_map_f")
  nnoremap <silent> f :<c-u>WhichKey 'f'<CR>
  silent! call which_key#register('t', "g:which_key_map_t")
  nnoremap <silent> t :<c-u>WhichKey 't'<CR>

  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

  let g:which_key_map   = {}
  let g:which_key_map_f = {}
  let g:which_key_map_t = {}

  let g:which_key_map_f.h = { 'name' : '+History' }
  let g:which_key_map_t.r = 'tag references'
  let g:which_key_map_t.d = 'tag define'
  let g:which_key_map_t.n = 'tag next'
  let g:which_key_map_t.p = 'tag previous'
  let g:which_key_map_t.g = 'tag gen'
  let g:which_key_map_t.r = 'tag remove'

  let g:which_key_map.a   = { 'name' : '+AnyJump' }
  let g:which_key_map.m   = { 'name' : '+Bookmark' }
  let g:which_key_map.c   = { 'name' : '+QuickFix--cd--color' }
  let g:which_key_map.d   = { 'name' : '+DeleteSth' }
  let g:which_key_map.e   = { 'name' : '+EditSth' }
  let g:which_key_map.e.v = { 'name' : '+vim_config' }
  let g:which_key_map.g   = { 'name' : '+Comment' }
  let g:which_key_map.p   = { 'name' : '+Plug' }
  let g:which_key_map.r   = { 'name' : '+Ref--Coc' }
  let g:which_key_map.t   = { 'name' : '+Tab--Tagbar--Template' }
  let g:which_key_map['w'] = {
      \ 'name' : '+Windows' ,
      \ 'f' : 'FileExplorer'                           ,
      \ 'l' : 'FileLocation'                           ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5' , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5' , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ }
endif

if (HasPlug('vim-quickui') != -1) "{{{
  silent! call quickui#menu#reset()

  silent! call quickui#menu#install('&File', [
        \ [ "&New File\tCtrl+n", 'echo 0' ],
        \ [ "&Open File\t(F3)", 'echo 1' ],
        \ [ "&Close", 'echo 2' ],
        \ [ "--", '' ],
        \ [ "&Save\tCtrl+s", 'echo 3'],
        \ [ "Save &As", 'echo 4' ],
        \ [ "Save All", 'echo 5' ],
        \ [ "--", '' ],
        \ [ "E&xit\tAlt+x", 'echo 6' ],
        \ ])

  silent! call quickui#menu#install('&Edit', [
        \ [ '&Copy', 'echo 1', 'help 1' ],
        \ [ '&Paste', 'echo 2', 'help 2' ],
        \ [ '&Find', 'echo 3', 'help 3' ],
        \ ])

  silent! call quickui#menu#install('&Build', [
        \ [ '&Build', 'AsyncTask build', 'build project' ],
        \ ])


  silent! call quickui#menu#install("&Option", [
        \ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
        \ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
        \ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
        \ ])

  let g:quickui_show_tip = 1

  noremap <space><space> :call quickui#menu#open()<cr>
endif "}}}

"}}}



" ============================================================================
" pvimrc {{{
" ============================================================================
" auto update pvimrc var
" init backup
let g:b_Lf_MruFileExclude = deepcopy(g:Lf_MruFileExclude)
let g:b_Lf_WildIgnore = deepcopy(g:Lf_WildIgnore)
let g:b_Lf_RgConfig = deepcopy(g:Lf_RgConfig)
let g:b_gen_clang_conf#ignore_dirs = deepcopy(g:gen_clang_conf#ignore_dirs)

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
  for i in g:custom_ignore['rg']
    call add(g:Lf_RgConfig, i)
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
