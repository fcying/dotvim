"let g:plug_manager = 'vim-plug'
let g:plug_manager = 'packer'
"let g:plug_manager = 'none'

if g:is_nvim ==# 0
  let g:plug_manager = 'vim-plug'
endif

let g:plug_names = {}
let g:plug_options = []
if !exists('g:plug_dir')
  let g:plug_dir = g:root_dir . '/.plugged'
endif
let s:plug_install_dir = g:plug_dir . '/pack/packer/opt'
let s:plug_init = 0
let g:plug_need_update = 0

" init env {{{
if g:plug_manager ==# 'packer'
  "for packer_compiled.lua
  exec 'set runtimepath^=' . g:plug_dir
  exec 'set packpath=' . g:plug_dir
  let s:plug_manager_file = s:plug_install_dir . '/packer.nvim/lua/packer.lua'
  let s:plug_manager_download =
        \ 'silent !git clone --depth 1 https://github.com/wbthomason/packer.nvim '
        \ . s:plug_install_dir . '/packer.nvim'
elseif g:plug_manager ==# 'vim-plug'
  let s:plug_manager_file = s:plug_install_dir . '/vim-plug/plug.vim'
  let s:plug_manager_download =
        \ 'silent !git clone --depth 1 https://github.com/junegunn/vim-plug '
        \ . s:plug_install_dir . '/vim-plug'
else
  "not plugin
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
  if g:plug_manager ==# 'packer'
    call add(l:plug, a:repo)
    let l:options = {}
    let l:options.opt = 'false'
    if a:0 != 0
      for key in keys(a:1)
        if key ==# 'keys' || key ==# 'ft' || key ==# 'cmd' || key ==# 'event'
              \ || key ==# 'fn' || key ==# 'after'
              \ || key ==# 'module' || key ==# 'module_pattern'
          let l:options.opt = 'true'
          exec 'let l:options.' . key . ' = a:1[key]'
        elseif key ==# 'run'
          if type(a:1[key]) ==# 1
            exec 'let l:options.' . key . ' = a:1[key]'
          else
            exec 'let l:options.' . key . ' = string(a:1[key])'
          endif
        elseif key ==# 'rtp' || key ==# 'commit' || key ==# 'branch'
              \ || key ==# 'requires' || key ==# 'config'
          exec 'let l:options.' . key . ' = a:1[key]'
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
      let g:plug_need_update = 1
    endif
  endif
endfunction
command! -nargs=+ -bar MyPlug call MyPlug(<args>)


function! MyPlugUpgrade()
  if g:plug_manager ==# 'packer'
    lua require('config').packer()

    nnoremap <leader>pu :PackerSync<CR>
    nnoremap <leader>pr :PackerClean<CR>
    nnoremap <leader>pc :PackerCompile<CR>

  elseif g:plug_manager ==# 'vim-plug'
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
MyPlug 'fcying/gen_clang_conf.vim'
MyPlug 'wsdjeg/vim-fetch'
MyPlug 'tpope/vim-sleuth'

MyPlug 'moll/vim-bbye', {'cmd':'Bdelete'}
MyPlug 'preservim/nerdcommenter', {'keys':'<plug>NERDCommenter'}
MyPlug 'lambdalisue/fern.vim', {'cmd':'Fern'}
MyPlug 'machakann/vim-sandwich'
MyPlug 'dstein64/vim-startuptime', {'cmd':'StartupTime'}
MyPlug 'mbbill/fencview', {'cmd':['FencView','FencAutoDetect']}

MyPlug 'liuchengxu/vim-which-key'
MyPlug 't9md/vim-choosewin', {'keys':'<Plug>(choosewin)'}
MyPlug 'preservim/tagbar', {'cmd':'TagbarToggle'}
MyPlug 'Yggdroot/indentLine', {'cmd': 'IndentLinesToggle'}
"MyPlug 'MattesGroeger/vim-bookmarks'
MyPlug 'chentoast/marks.nvim', {'config':'marks', 'event':'VimEnter'}

MyPlug 'tpope/vim-fugitive' , {'cmd': ['G', 'Git', 'Gedit', 'Gread', 'Gwrite', 'Gdiffsplit', 'Gvdiffsplit'], 'fn': 'fugitive#*'}
MyPlug 'rbong/vim-flog', {'cmd': ['Flog', 'Flogsplit', 'Floggit'], 'require': 'tpope/vim-fugitive', 'branch': 'master'}

MyPlug 'mg979/vim-visual-multi', {'branch': 'master'}
MyPlug 'easymotion/vim-easymotion', {'keys':'<Plug>(easymotion'}
MyPlug 'mhinz/vim-grepper', {'keys':'<plug>(GrepperOperator)'}
MyPlug 'terryma/vim-expand-region'
MyPlug 'andymass/vim-matchup'
MyPlug 'fcying/vim-foldsearch', {'cmd': ['Fp', 'Fw', 'Fs', 'FS', 'Fl', 'Fi', 'Fd', 'Fe']}
MyPlug 'chrisbra/Colorizer'

if g:is_nvim
  " telescope {{{
  MyPlug 'nvim-lua/plenary.nvim'
  MyPlug 'nvim-telescope/telescope.nvim', {'config': 'telescope', 'cmd': 'Telescope', 'module_pattern': 'telescope.*'}
  "MyPlug 'nvim-telescope/telescope.nvim'
  MyPlug 'fcying/telescope-ctags-outline.nvim'
  MyPlug 'nvim-telescope/telescope-fzf-native.nvim', { 'run': 'make' }

  MyPlug 'lewis6991/impatient.nvim', {'opt': 'true'}
  MyPlug 'kevinhwang91/nvim-bqf', {'ft':'qf'}
  MyPlug 'rcarriga/nvim-notify', {'config':'notify', 'event':'VimEnter'}
  MyPlug 'nvim-lualine/lualine.nvim', {'config':'lualine', 'event':'VimEnter'}

  "MyPlug 'kevinhwang91/nvim-hclipboard'
  " FIXME nvim cursorhold bug https://github.com/neovim/neovim/issues/12587
  MyPlug 'antoinemadec/FixCursorHold.nvim'
else
  MyPlug 'tmux-plugins/vim-tmux-focus-events'
  MyPlug 'roxma/vim-tmux-clipboard'
  MyPlug 'itchyny/lightline.vim'
endif

if g:use_leaderf ==# 1
  MyPlug 'Yggdroot/LeaderF', {'run': ':LeaderfInstallCExtension', 'cmd': 'Leaderf'}
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
  MyPlug 'williamboman/nvim-lsp-installer'
  MyPlug 'neovim/nvim-lspconfig'
  MyPlug 'folke/lua-dev.nvim'
  MyPlug 'hrsh7th/nvim-cmp', {'config':'cmp', 'event':'InsertEnter'}
  MyPlug 'hrsh7th/cmp-path', {'after':'nvim-cmp'}
  MyPlug 'hrsh7th/cmp-nvim-lsp', {'after':'nvim-cmp'}
  MyPlug 'hrsh7th/cmp-vsnip', {'after':'nvim-cmp'}
  MyPlug 'hrsh7th/vim-vsnip', {'after':'nvim-cmp'}
  MyPlug 'hrsh7th/cmp-buffer', {'after':'nvim-cmp'}
  MyPlug 'hrsh7th/cmp-cmdline', {'after':'nvim-cmp'}
  MyPlug 'hrsh7th/cmp-omni', {'after':'nvim-cmp'}
  MyPlug 'quangnguyen30192/cmp-nvim-tags', {'after':'nvim-cmp'}
  MyPlug 'uga-rosa/cmp-dictionary', {'after':'nvim-cmp', 'config':'cmp_dictionary'}
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
