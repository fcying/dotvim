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
"MyPlug 'dstein64/vim-startuptime', {'cmd':'StartupTime'}
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
MyPlug 'mhinz/vim-grepper'

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
MyPlug 'rbong/vim-flog'

"MyPlug 'skywind3000/vim-preview'
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
  MyPlug 'kevinhwang91/nvim-bqf', {'ft':'qf'}
  MyPlug 'hrsh7th/nvim-cmp'
  MyPlug 'hrsh7th/cmp-nvim-lsp'
  MyPlug 'hrsh7th/cmp-path'
  MyPlug 'hrsh7th/cmp-buffer'
  MyPlug 'hrsh7th/cmp-cmdline'
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


execute 'source ' . g:config_dir . '/config.vim'

if g:is_nvim
  lua require 'config'
endif

