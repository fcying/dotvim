let g:plug_names = {}
let g:plug_options = []

" vim-plug packer.nvim
"let s:plug_manager = 'vim-plug'
let s:plug_manager = 'packer'
"let s:plug_manager = 'none'

if g:is_nvim ==# 0
  let s:plug_manager = 'vim-plug'
endif

let g:plug_dir = g:config_dir . '/.plugged'
let s:plug_install_dir = g:plug_dir . '/pack/packer/opt'
let s:plug_init = 0
let s:plug_need_update = 0

" init env {{{
if s:plug_manager ==# 'packer'
  "for packer_compiled.lua
  exec 'set runtimepath^=' . g:plug_dir
  exec 'set packpath=' . g:plug_dir
  let s:plug_manager_file = s:plug_install_dir . '/packer.nvim/lua/packer.lua'
  let s:plug_manager_download =
        \ 'silent !git clone --depth 1 https://github.com/wbthomason/packer.nvim '
        \ . s:plug_install_dir . '/packer.nvim'
elseif s:plug_manager ==# 'vim-plug'
  let s:plug_manager_file = s:plug_install_dir . '/vim-plug/plug.vim'
  let s:plug_manager_download =
        \ 'silent !git clone --depth 1 https://github.com/junegunn/vim-plug '
        \ . s:plug_install_dir . '/vim-plug'
else
  "not plugin
  let g:plug_dir = g:config_dir
  let s:plug_manager_file = g:file_vimrc
endif

" downlaod plug manager {{{
if filereadable(expand(s:plug_manager_file)) == 0
  if executable('git')
    if filereadable(expand(g:file_vimrc_local)) == 0
      call writefile([
            \ '"let g:complete_engine=''nvimlsp''',
            \ '"let g:colorscheme=''solarized8''',
            \ '"let g:background=''light''',
            \ 'function! LoadAfter()',
            \ 'endfunc',
            \ ], expand(g:file_vimrc_local), 'a')
    endif
    exec s:plug_manager_download
    if filereadable(expand(s:plug_manager_file)) == 0
      echohl WarningMsg
      echom 'install plug manager failed!'
      echohl None
    else
      let s:plug_init = 1
    endif
  else
    echohl WarningMsg
    echom 'You need install git!'
    echohl None
  endif
endif

" find plugin {{{
function! HasPlug(name) abort
  if get(g:plug_names, a:name) ==# 1
    return 1
  endif
  return -1
endfunction

function! MyPlug(repo, ...)
  let l:plug = []
  let l:plug_name = fnamemodify(a:repo, ':t:s?\.git$??')

  " packer.nvim
  if s:plug_manager ==# 'packer'
    call add(l:plug, a:repo)
    let l:options = {}
    let l:options.opt = 'false'
    if a:0 != 0
      for key in keys(a:1)
        if key ==# 'keys'
          let l:options.opt = 'true'
          let l:options.keys = a:1[key]
        elseif key ==# 'ft'
          let l:options.opt = 'true'
          let l:options.ft = a:1[key]
        elseif key ==# 'cmd'
          let l:options.opt = 'true'
          let l:options.cmd = a:1[key]
        elseif key ==# 'event'
          let l:options.opt = 'true'
          let l:options.event = a:1[key]
        elseif key ==# 'run'
          let l:options.run = substitute(string(a:1[key]), 'function(''\(.*\)'')', '\1', 'g')
        elseif key ==# 'rtp'
          let l:options.rtp = a:1[key]
        elseif key ==# 'commit'
          let l:options.commit = a:1[key]
        elseif key ==# 'branch'
          let l:options.branch = a:1[key]
        endif
      endfor
    endif

    if isdirectory(s:plug_install_dir . '/' . l:plug_name)
      exec 'let g:plug_names[''' . l:plug_name . '''] = 1'
      if l:options.opt ==# 'false'
          exe 'packadd! '. l:plug_name
      endif
    else
      exec 'let g:plug_names[''' . l:plug_name . '''] = 0'
      let s:plug_need_update = 1
    endif
    call add(l:plug, l:options)
    call add(g:plug_options, l:plug)
    "echo l:plug

  elseif s:plug_manager ==# 'vim-plug'
    call add(l:plug, a:repo)
    if a:0 != 0
      let l:options = {}
      for key in keys(a:1)
        if key ==# 'cmd'
          exec "let l:options.on = a:1[key]"
        elseif key ==# 'run'
          exec "let l:options.do = a:1[key]"
        elseif key ==# 'branch'
          exec "let l:options.branch = a:1[key]"
        elseif key ==# 'ft'
          exec "let l:options.for = a:1[key]"
        endif
      endfor
      call add(l:plug, l:options)
    endif
    call add(g:plug_options, l:plug)
    if isdirectory(s:plug_install_dir . '/' . l:plug_name)
      exec 'let g:plug_names[''' . l:plug_name . '''] = 1'
    else
      exec 'let g:plug_names[''' . l:plug_name . '''] = 0'
      let s:plug_need_update = 1
    endif
  endif
endfunction
command! -nargs=+ -bar MyPlug call MyPlug(<args>)


" install function {{{
function! InstallLeaderF(info) abort
  if s:plug_manager ==# 'packer'
    if g:is_win
      exe 'silent !cd /d ' . s:plug_install_dir . '\LeaderF && .\install.bat'
    else
      exe 'silent !cd ' . s:plug_install_dir . '/LeaderF && ./install.sh'
    endif
  else
    if g:is_win
      silent !.\install.bat
    else
      silent !./install.sh
    endif
  endif
  silent !pip3 install pygments --upgrade
endfunction

" plugin list {{{
MyPlug 'mbbill/fencview', {'cmd':['FencView','FencAutoDetect']}
MyPlug 'wsdjeg/vim-fetch'
MyPlug 'lambdalisue/suda.vim', {'cmd':['SudaRead', 'SudaWrite']}
MyPlug 'moll/vim-bbye', {'cmd':'Bdelete'}
MyPlug 'itchyny/lightline.vim'
MyPlug 'simnalamburt/vim-mundo'
MyPlug 'chrisbra/Colorizer'
MyPlug 'skywind3000/vim-quickui'
MyPlug 'liuchengxu/vim-which-key'
MyPlug 'tweekmonster/startuptime.vim', {'cmd':'StartupTime'}
"MyPlug 'tpope/vim-apathy'
"MyPlug 'roxma/vim-paste-easy'

if g:is_nvim
  "MyPlug 'nathom/filetype.nvim'
  " FIXME nvim cursorhold bug https://github.com/neovim/neovim/issues/12587
  MyPlug 'antoinemadec/FixCursorHold.nvim'
  " FIXME https://github.com/neovim/neovim/issues/14967 in 0.5.0
  "MyPlug 'kevinhwang91/nvim-hclipboard'
endif

MyPlug 'machakann/vim-sandwich'
MyPlug 'terryma/vim-expand-region'
MyPlug 'mg979/vim-visual-multi', {'branch': 'master'}

MyPlug 't9md/vim-choosewin', {'cmd':'<Plug>(choosewin)'}
"MyPlug 'preservim/nerdtree', {'cmd':['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind']}
MyPlug 'lambdalisue/fern.vim', {'cmd':'Fern'}
MyPlug 'preservim/nerdcommenter', {'keys':'<plug>NERDCommenter'}
MyPlug 'preservim/tagbar', {'cmd':'TagbarToggle'}
MyPlug 'andymass/vim-matchup'
"MyPlug 'andymass/vim-matchup', {'event': 'VimEnter'}
MyPlug 'fcying/vim-foldsearch'
"MyPlug 'Krasjet/auto.pairs'
MyPlug 'easymotion/vim-easymotion', {'keys':'<Plug>(easymotion'}
"MyPlug 'justinmk/vim-sneak'
"MyPlug 'aperezdc/vim-template', {'cmd':'TemplateHere'}

MyPlug 'Vimjas/vim-python-pep8-indent', {'ft':'python'}
MyPlug 'cespare/vim-toml', {'ft': 'toml', 'branch': 'main'}
MyPlug 'peterhoeg/vim-qml', {'ft': 'qml'}
MyPlug 'neoclide/jsonc.vim', {'ft': 'jsonc'}
MyPlug 'othree/xml.vim', {'ft': 'xml'}
MyPlug 'wsdjeg/vim-autohotkey', {'ft':'autohotkey'}
MyPlug 'godlygeek/tabular', {'ft':'markdown'}
MyPlug 'plasticboy/vim-markdown', {'ft':'markdown'}

MyPlug 'Yggdroot/LeaderF', {'run': function('InstallLeaderF')}

MyPlug 'MattesGroeger/vim-bookmarks'
MyPlug 'derekwyatt/vim-fswitch'
MyPlug 'Yggdroot/indentLine', {'cmd': 'IndentLinesToggle'}
if g:is_nvim ==# 0
  MyPlug 'xolox/vim-misc'
  "MyPlug 'xolox/vim-session'
endif
MyPlug 'tpope/vim-fugitive'

MyPlug 'skywind3000/vim-preview'
MyPlug 'skywind3000/asyncrun.vim', {'cmd': ['AsyncRun', 'AsyncStop'] }
MyPlug 'skywind3000/asynctasks.vim', {'cmd': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }

MyPlug 'fcying/gen_clang_conf.vim'
"MyPlug 'w0rp/ale'

if g:is_nvim ==# 0
  MyPlug 'tmux-plugins/vim-tmux-focus-events'
  MyPlug 'roxma/vim-tmux-clipboard'
endif

" color {{{
MyPlug 'tomasr/molokai'
MyPlug 'lifepillar/vim-solarized8'
MyPlug 'lifepillar/vim-gruvbox8'

" complete_engine
if g:complete_engine ==# 'coc'
  MyPlug 'neoclide/coc.nvim', {'branch': 'release'}
  if g:is_win ==# 0
    MyPlug 'wellle/tmux-complete.vim'
  endif
  MyPlug 'honza/vim-snippets'

elseif g:complete_engine ==# 'nvimlsp'
  MyPlug 'nvim-lua/plenary.nvim'
  MyPlug 'nvim-telescope/telescope.nvim'
  MyPlug 'neovim/nvim-lspconfig'
  MyPlug 'williamboman/nvim-lsp-installer'
  MyPlug 'hrsh7th/nvim-cmp'
  MyPlug 'hrsh7th/cmp-nvim-lsp'
  MyPlug 'hrsh7th/cmp-buffer'
  MyPlug 'hrsh7th/cmp-path'
  MyPlug 'hrsh7th/cmp-nvim-lua', {'ft': 'lua'}
  MyPlug 'quangnguyen30192/cmp-nvim-tags'
  "MyPlug 'andersevenrud/compe-tmux', {'branch': 'cmp'}
  MyPlug 'hrsh7th/cmp-vsnip'
  MyPlug 'hrsh7th/vim-vsnip'

elseif g:complete_engine ==# 'ycm'
  MyPlug 'ycm-core/YouCompleteMe', {'run': 'python3 install.py --all'}
endif


" plugin manager setting {{{
if s:plug_manager ==# 'packer'
  packadd packer.nvim
lua << EOF
  local packer = require("packer")
  local use = packer.use

  packer.init({
    package_root = vim.g.plug_dir .. '/pack',
    compile_path  = vim.g.plug_dir .. '/plugin/packer_compiled.lua',
    plugin_package = 'packer',
    auto_clean = false,
  })

  use({'wbthomason/packer.nvim', opt = true})
  for key, value in ipairs(vim.g.plug_options) do
    local path, opt
    local options = {value[1]}
    if (value[2] ~= "nil") then
      for k, v in pairs(value[2]) do
        options[k] = v
      end
      if (value[2]['run'] ~= nil) then
        options['run'] = function() vim.fn[value[2]['run']](0) end
      end
    end
    options['opt'] = true
    use(options)
    --print(vim.inspect(options))
  end
EOF

  nnoremap <leader>pu :PackerSync<CR>
  nnoremap <leader>pi :PackerInstall<CR>
  nnoremap <leader>pr :PackerClean<CR>
  nnoremap <leader>pc :PackerCompile<CR>

elseif s:plug_manager ==# 'vim-plug'
  exec 'source '. s:plug_install_dir . '/vim-plug/plug.vim'
  call plug#begin(expand(s:plug_install_dir))
  Plug 'junegunn/vim-plug'

  for plug in g:plug_options
    if len(plug) ==# 2
      exec "Plug plug[0], plug[1]"
    else
      exec "Plug plug[0]"
    endif
  endfor

  call plug#end()
  delc PlugUpgrade
  nnoremap <leader>pu :PlugUpdate<CR>
  nnoremap <leader>pi :PlugInstall<CR>
  nnoremap <leader>pc :PlugClean<CR>
endif


" init plugin {{{
if s:plug_init ==# 1
  let g:colorscheme = 'default'
endif
autocmd myau VimEnter *
      \ if s:plug_need_update ==# 1
      \ |   call feedkeys("\<space>pu", "tx")
      \ | endif



" ============================================================================
" plug setting {{{
" ============================================================================
execute 'source ' . g:config_dir . '/config.vim'

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

if (HasPlug('FixCursorHold.nvim') != -1) "{{{
  let g:cursorhold_updatetime = 300
endif "}}}

if (HasPlug('nvim-hclipboard') != -1) "{{{
  lua require('hclipboard').start()
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

if (HasPlug('coc.nvim') != -1) "{{{
  let g:coc_data_home = g:cache_dir . '/coc'
  let g:coc_config_home = g:config_dir
  let $NVIM_COC_LOG_FILE=g:coc_data_home . '/log'
  "'coc-pairs', 'coc-syntax'
  let g:coc_global_extensions = [
        \ 'coc-dictionary', 'coc-syntax',
        \ 'coc-rls', 'coc-go', 'coc-lua',
        \ 'coc-clangd', 'coc-cmake', 'coc-json',
        \ 'coc-marketplace'
        \ ]
  "call add(g:coc_global_extensions, 'coc-vimlsp')
  "call add(g:coc_global_extensions, 'coc-tsserver')
  "call add(g:coc_global_extensions, 'coc-docker')
  "call add(g:coc_global_extensions, 'coc-yaml')
  "call add(g:coc_global_extensions, 'coc-toml')
  "call add(g:coc_global_extensions, 'coc-css')
  "call add(g:coc_global_extensions, 'coc-html')
  "call add(g:coc_global_extensions, 'coc-xml')
  "call add(g:coc_global_extensions, 'coc-java')
  call add(g:coc_global_extensions, 'coc-snippets')
  call add(g:coc_global_extensions, 'coc-pyright')

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

  " Remap for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
    nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"
    vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
    vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"
  endif

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


if (HasPlug('tmux-complete.vim') != -1) "{{{
  let g:tmuxcomplete#trigger = 'omnifunc'
endif

if (HasPlug('vim-sandwich') != -1) "{{{
  let g:sandwich_no_default_key_mappings = 1
  let g:textobj_sandwich_no_default_key_mappings = 1
  let g:operator_sandwich_no_default_key_mappings = 1
  nmap <leader>srb <Plug>(operator-sandwich-replace)
        \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  nmap <leader>sdb <Plug>(operator-sandwich-delete)
        \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  nmap <leader>sr <Plug>(operator-sandwich-replace)
        \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  nmap <leader>sd <Plug>(operator-sandwich-delete)
        \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  xmap <leader>sr <Plug>(operator-sandwich-replace)
  xmap <leader>sd <Plug>(operator-sandwich-delete)
  omap <leader>sa <Plug>(operator-sandwich-g@)
  xmap <leader>sa <Plug>(operator-sandwich-add)
  nmap <leader>sa <Plug>(operator-sandwich-add)
endif

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
    nmap <buffer> d <Plug>(fern-action-remove)
    nmap <buffer> q :<C-u>quit<CR>
  endfunction
endif "}}}

if (HasPlug('vim-session') != -1) "{{{
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
  let g:session_directory = g:cache_dir . '/sessions'
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

  let g:Lf_PreviewInPopup = 1
  "let g:Lf_WindowPosition = 'popup'
  "let g:Lf_PreviewHorizontalPosition = 'right'

  let g:Lf_CommandMap = {
        \ '<F5>': ['<C-L>'],
        \ }
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

  let g:Lf_ShortcutF = ''
  let g:Lf_ShortcutB = ''
  nnoremap ff :<C-u>Leaderf file --fullPath<CR>
  nnoremap fm :<C-u>Leaderf mru --fullPath<CR>
  nnoremap fb :<C-u>Leaderf buffer --fullPath<CR>
  nnoremap fo :<C-u>Leaderf function --fullPath<CR>
  nnoremap fl :<C-u>Leaderf line --fuzzy<CR>
  nnoremap fh :<C-u>Leaderf help --fuzzy<CR>
  nnoremap ft :<C-u>Leaderf tag --fuzzy<CR>
  nnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w %s", expand("<cword>"))<CR>
  nnoremap fG :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -w ")<CR>
  xnoremap fg :<C-u><C-R>=printf("Leaderf! rg --wd-mode=c -F %s", leaderf#Rg#visual())<CR>
  nnoremap f/ :<C-U>Leaderf rg<CR>
  nnoremap fj :<C-U>Leaderf jumps<CR>
  nnoremap fr :<C-U>Leaderf --recall<CR><TAB>

  nnoremap fi :exec "Leaderf file --fullPath --input " . <SID>strip_include(getline("."))<CR>
  function! s:strip_include(line)
    let l:strip_include = substitute(a:line, '\v.*[\<"]([a-zA-Z0-9_/\.]+)[\>"]', '\1', 'g')
    return l:strip_include
  endfunction
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

if (HasPlug('fencview') != -1) "{{{
  let g:fencview_autodetect = 1
  let g:fencview_checklines = 10
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

if (HasPlug('vim-fswitch') != -1) "{{{
  if (HasPlug('coc.nvim') ==# -1)
    autocmd myau FileType c,cpp nnoremap <silent> <buffer> <leader>h <ESC>:FSHere<CR>
  endif
endif "}}}

if (HasPlug('vim-template') != -1) "{{{
  nnoremap <silent> <Leader>th :TemplateHere<CR>
  nnoremap <silent> <Leader>tf :execute 'Template *.' . &filetype<CR>
  let g:templates_no_autocmd = 1
  let g:templates_directory = g:config_dir . '/template'
  let g:user = get(g:, 'user', 'fcying')
  let g:email = get(g:, 'email', 'fcying@gmail.com')
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

if g:is_nvim
  exec 'luafile ' . g:config_dir . '/config.lua'
endif

