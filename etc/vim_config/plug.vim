"let g:plug_manager = 'vim-plug'
let g:plug_manager = 'lazy'
"let g:plug_manager = 'none'

if g:is_nvim ==# 0
  let g:plug_manager = 'vim-plug'
endif

let g:plug_names = {}
let g:plug_options = []
if !exists('g:plug_dir')
  let g:plug_dir = g:root_dir . '/.plugged'
endif
let s:plug_init = 0
let g:plug_need_update = 0

" init env {{{
if g:plug_manager ==# 'lazy'
  let s:plug_manager_file = g:plug_dir . '/lazy.nvim/README.md'
  let s:plug_manager_download =
        \ 'silent !git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable '
        \ . g:plug_dir . '/lazy.nvim'
elseif g:plug_manager ==# 'vim-plug'
  let s:plug_manager_file = g:plug_dir . '/vim-plug/plug.vim'
  let s:plug_manager_download =
        \ 'silent !git clone --depth 1 https://github.com/junegunn/vim-plug '
        \ . g:plug_dir . '/vim-plug'
else
  "not plugin manager
  let g:plug_dir = g:root_dir
  let s:plug_manager_file = g:config_dir . '/plug.vim'
endif

" Bootstrapping {{{
if filereadable(expand(s:plug_manager_file)) == 0
  if executable('git')
    "if filereadable(expand(g:file_vimrc_local)) == 0
    "  call writefile([
    "        \ '"let g:complete_engine=''nvimlsp''',
    "        \ '"let g:colorscheme=''solarized8''',
    "        \ '"let g:background=''light''',
    "        \ 'function! LoadAfter()',
    "        \ 'endfunc',
    "        \ ], expand(g:file_vimrc_local), 'a')
    "endif
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
  if g:plug_manager ==# 'lazy'
    call add(l:plug, a:repo)
    let l:options = {}
    let l:verylazy = 1
    if a:0 != 0
      for key in keys(a:1)
        if key ==# 'keys' || key ==# 'ft' || key ==# 'cmd' || key ==# 'event'
              \ || key ==# 'lazy'
          let l:verylazy = 0
          exec 'let l:options.' . key . ' = a:1[key]'
        elseif key ==# 'dependencies' || key ==# 'config' || key ==# 'version'
              \ || key ==# 'commit' || key ==# 'branch' || key ==# 'tag'
              \ || key ==# 'build'
          exec 'let l:options.' . key . ' = a:1[key]'
        endif
      endfor
    endif

    "if l:verylazy
    "  let l:options.event = 'VimEnter'
    "endif
    
    if isdirectory(g:plug_dir . '/' . l:plug_name)
      exec 'let g:plug_names[''' . l:plug_name . '''] = 1'
    else
      exec 'let g:plug_names[''' . l:plug_name . '''] = 0'
      let g:plug_need_update = 1
    endif
    call add(l:plug, l:options)
    call add(g:plug_options, l:plug)
    "echo l:plug

  elseif g:plug_manager ==# 'vim-plug'
    call add(l:plug, a:repo)
    if a:0 != 0
      let l:options = {}
      for key in keys(a:1)
        if key ==# 'build'
          exec "let l:options.do = a:1[key]"
        elseif key ==# 'cmd'
          exec "let l:options.on = a:1[key]"
        elseif key ==# 'branch'
          exec "let l:options.branch = a:1[key]"
        elseif key ==# 'ft'
          exec "let l:options.for = a:1[key]"
        endif
      endfor
      call add(l:plug, l:options)
    endif
    call add(g:plug_options, l:plug)
    if isdirectory(g:plug_dir . '/' . l:plug_name)
      exec 'let g:plug_names[''' . l:plug_name . '''] = 1'
    else
      exec 'let g:plug_names[''' . l:plug_name . '''] = 0'
      let g:plug_need_update = 1
    endif
  endif
endfunction
command! -nargs=+ -bar MyPlug call MyPlug(<args>)


function! MyPlugUpgrade()
  if g:plug_manager ==# 'lazy'
    lua require('config').lazy()

    nnoremap <leader>pu :Lazy update<CR>
    nnoremap <leader>pr :Lazy clean<CR>

  elseif g:plug_manager ==# 'vim-plug'
    exec 'source '. g:plug_dir . '/vim-plug/plug.vim'
    call plug#begin(expand(g:plug_dir))
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
    nnoremap <leader>pr :PlugClean<CR>

    if g:plug_need_update ==# 1 || g:force_update ==# 1
      PlugUpdate --sync
    endif

  endif

  execute 'source ' . g:config_dir . '/config.vim'
  call UpdateIgnore()
endfunction


" init plugin {{{
if s:plug_init ==# 1
  let g:colorscheme = 'default'
endif


" ============================================================================
" common plugins {{{
" ============================================================================
MyPlug 'fcying/gen_clang_conf.vim', {'event': 'VeryLazy'}
MyPlug 'wsdjeg/vim-fetch', {'lazy': v:false}

MyPlug 'lambdalisue/suda.vim', {'cmd':['SudaRead', 'SudaWrite']}
MyPlug 'simnalamburt/vim-mundo', {'event': 'VimEnter'}
"MyPlug 'skywind3000/vim-quickui'
"MyPlug 'tpope/vim-apathy'
"MyPlug 'roxma/vim-paste-easy'
"MyPlug 'derekwyatt/vim-fswitch'

" automatically adjusts 'shiftwidth' and 'expandtab'
MyPlug 'tpope/vim-sleuth', {'event': 'VeryLazy'}

MyPlug 'moll/vim-bbye', {'cmd':'Bdelete', 'event': 'VeryLazy'}
MyPlug 'preservim/nerdcommenter', {'event': 'VeryLazy'}
MyPlug 'lambdalisue/fern.vim', {'cmd':'Fern', 'event': 'VeryLazy'}
MyPlug 'machakann/vim-sandwich', {'event': 'VeryLazy'}
MyPlug 'dstein64/vim-startuptime', {'cmd':'StartupTime'}
MyPlug 'mbbill/fencview', {'cmd':['FencView','FencAutoDetect']}

MyPlug 'ZSaberLv0/ZFVimJob'
MyPlug 'ZSaberLv0/ZFVimDirDiff', {'cmd':'ZFDirDiff', 'dependencies':['ZFVimJob']}

MyPlug 'liuchengxu/vim-which-key', {'event': 'VimEnter'}
MyPlug 't9md/vim-choosewin', {'event': 'VimEnter'}
MyPlug 'preservim/tagbar', {'cmd':'TagbarToggle'}
MyPlug 'Yggdroot/indentLine', {'cmd': 'IndentLinesToggle'}
"MyPlug 'MattesGroeger/vim-bookmarks'
MyPlug 'chentoast/marks.nvim', {'config':'marks', 'event': 'VimEnter'}

MyPlug 'tpope/vim-fugitive', {'event': 'VeryLazy'}
MyPlug 'rbong/vim-flog', {'cmd': ['Flog', 'Flogsplit', 'Floggit'], 'branch': 'master'}
MyPlug 'iberianpig/tig-explorer.vim', {'event': 'VimEnter'}

MyPlug 'mg979/vim-visual-multi', {'branch': 'master', 'event': 'VimEnter'}
MyPlug 'easymotion/vim-easymotion', {'event': 'VimEnter'}
MyPlug 'mhinz/vim-grepper', {'event': 'VimEnter'}
MyPlug 'terryma/vim-expand-region', {'event': 'VimEnter'}
MyPlug 'andymass/vim-matchup', {'event': 'VimEnter'}
MyPlug 'fcying/vim-foldsearch', {'cmd': ['Fp', 'Fw', 'Fs', 'FS', 'Fl', 'Fi', 'Fd', 'Fe']}
MyPlug 'chrisbra/Colorizer', {'event': 'VimEnter'}

if g:is_nvim
  " telescope {{{
  MyPlug 'nvim-lua/plenary.nvim', {'event': 'VeryLazy'}
  MyPlug 'nvim-telescope/telescope.nvim', {'config': 'telescope', 'cmd': 'Telescope'}
  MyPlug 'fcying/telescope-ctags-outline.nvim'
  MyPlug 'nvim-telescope/telescope-fzf-native.nvim', { 'build': 'make' }

  MyPlug 'kevinhwang91/nvim-bqf', {'ft':'qf'}
  MyPlug 'rcarriga/nvim-notify', {'config':'notify', 'event': 'VimEnter'}
  MyPlug 'nvim-lualine/lualine.nvim', {'config':'lualine', 'event':'ColorScheme'}

  "MyPlug 'kevinhwang91/nvim-hclipboard'
else
  MyPlug 'tmux-plugins/vim-tmux-focus-events'
  MyPlug 'roxma/vim-tmux-clipboard'
  MyPlug 'itchyny/lightline.vim'
endif

if g:use_leaderf ==# 1
  MyPlug 'Yggdroot/LeaderF', {'build': ':LeaderfInstallCExtension', 'cmd': 'Leaderf'}
endif

MyPlug 'skywind3000/asyncrun.vim', {'cmd': ['AsyncRun', 'AsyncStop'] }
MyPlug 'skywind3000/asynctasks.vim', {'cmd': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }

" complete_engine: coc nvimlsp  {{{
let g:complete_engine = get(g:, 'complete_engine', 'nvimlsp')
if g:complete_engine ==# 'nvimlsp'
  if g:is_nvim ==# 0
    let g:complete_engine = 'coc'
  endif
endif

if g:complete_engine ==# 'nvimlsp'
  MyPlug 'williamboman/mason.nvim'
  MyPlug 'williamboman/mason-lspconfig.nvim'
  MyPlug 'jose-elias-alvarez/null-ls.nvim', {'config':'null_ls'}
  MyPlug 'neovim/nvim-lspconfig'
  MyPlug 'folke/neodev.nvim'
  MyPlug 'hrsh7th/nvim-cmp', {'config':'cmp', 'event':'InsertEnter'}
  MyPlug 'hrsh7th/cmp-path', {'dependencies':['nvim-cmp']}
  MyPlug 'hrsh7th/cmp-nvim-lsp', {'dependencies':['nvim-cmp']}
  MyPlug 'hrsh7th/cmp-vsnip', {'dependencies':['nvim-cmp']}
  MyPlug 'hrsh7th/vim-vsnip', {'dependencies':['nvim-cmp']}
  MyPlug 'hrsh7th/cmp-buffer', {'dependencies':['nvim-cmp']}
  MyPlug 'hrsh7th/cmp-cmdline', {'dependencies':['nvim-cmp']}
  MyPlug 'hrsh7th/cmp-omni', {'dependencies':['nvim-cmp']}
  MyPlug 'quangnguyen30192/cmp-nvim-tags', {'dependencies':['nvim-cmp']}
  MyPlug 'uga-rosa/cmp-dictionary', {'dependencies':['nvim-cmp'], 'config':'cmp_dictionary'}
  "MyPlug 'andersevenrud/compe-tmux', {'branch': 'cmp'}

elseif g:complete_engine ==# 'coc'
  MyPlug 'neoclide/coc.nvim', {'branch': 'release'}
  if g:is_win ==# 0
    MyPlug 'wellle/tmux-complete.vim'
  endif
  MyPlug 'honza/vim-snippets'
endif

" colorscheme {{{
MyPlug 'lifepillar/vim-solarized8'
MyPlug 'tomasr/molokai'
MyPlug 'sainnhe/everforest'

" filetype
MyPlug 'Vimjas/vim-python-pep8-indent', {'ft':'python'}
MyPlug 'cespare/vim-toml', {'ft': 'toml'}
MyPlug 'peterhoeg/vim-qml', {'ft': 'qml'}
MyPlug 'neoclide/jsonc.vim', {'ft': 'jsonc'}
MyPlug 'othree/xml.vim', {'ft': 'xml'}
MyPlug 'wsdjeg/vim-autohotkey', {'ft':'autohotkey'}
MyPlug 'godlygeek/tabular', {'ft':'markdown'}
MyPlug 'plasticboy/vim-markdown', {'ft':'markdown'}
