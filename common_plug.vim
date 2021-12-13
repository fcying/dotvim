" vim: set et fenc=utf-8 ff=unix sts=2 sw=2 ts=2 :

MyPlug 'fcying/gen_clang_conf.vim'
MyPlug 'wsdjeg/vim-fetch'
MyPlug 'itchyny/lightline.vim'

MyPlug 'moll/vim-bbye', {'cmd':'Bdelete'}
MyPlug 'preservim/nerdcommenter', {'keys':'<plug>NERDCommenter'}
MyPlug 'lambdalisue/fern.vim', {'cmd':'Fern'}
MyPlug 'machakann/vim-sandwich'

MyPlug 'tpope/vim-fugitive', {'cmd': ['Git', 'Gedit', 'Gread', 'Gwrite', 'Gdiffsplit', 'Gvdiffsplit'],
      \ 'fn': 'fugitive#*'}
MyPlug 'rbong/vim-flog', {'cmd': ['Flog', 'Flogsplit'], 'require': 'tpope/vim-fugitive'}

MyPlug 'mg979/vim-visual-multi', {'branch': 'master'}
MyPlug 'easymotion/vim-easymotion', {'keys':'<Plug>(easymotion'}
MyPlug 'mhinz/vim-grepper', {'keys':'<plug>(GrepperOperator)'}
MyPlug 'terryma/vim-expand-region'
MyPlug 'andymass/vim-matchup'
MyPlug 'fcying/vim-foldsearch', {'cmd': ['Fp', 'Fw', 'Fs', 'FS', 'Fl', 'Fi', 'Fd', 'Fe']}

if g:is_nvim
  MyPlug 'nvim-lua/plenary.nvim'
  MyPlug 'nvim-telescope/telescope.nvim', {'config': 'telescope', 'cmd': 'Telescope'}
  "MyPlug 'nvim-telescope/telescope.nvim'
  MyPlug 'nvim-telescope/telescope-fzf-native.nvim', { 'run': 'make' }
  MyPlug 'fcying/telescope-ctags-outline.nvim'
  MyPlug 'kevinhwang91/nvim-bqf', {'ft':'qf'}
  MyPlug 'rcarriga/nvim-notify'
  "MyPlug 'Yggdroot/LeaderF', {'run': function('InstallLeaderF')}
else
  MyPlug 'Yggdroot/LeaderF', {'run': function('InstallLeaderF')}
endif

" complete_engine
if g:complete_engine ==# 'coc'
  MyPlug 'neoclide/coc.nvim', {'branch': 'release'}
  if g:is_win ==# 0
    MyPlug 'wellle/tmux-complete.vim'
  endif
  MyPlug 'honza/vim-snippets'

elseif g:complete_engine ==# 'nvimlsp'
  MyPlug 'williamboman/nvim-lsp-installer'
  MyPlug 'neovim/nvim-lspconfig'
  MyPlug 'hrsh7th/nvim-cmp'
  MyPlug 'hrsh7th/cmp-path'
  MyPlug 'hrsh7th/cmp-nvim-lsp'
  MyPlug 'hrsh7th/cmp-buffer'
  MyPlug 'hrsh7th/cmp-cmdline'
  MyPlug 'hrsh7th/cmp-omni'
  MyPlug 'folke/lua-dev.nvim'
  MyPlug 'quangnguyen30192/cmp-nvim-tags'
  MyPlug 'uga-rosa/cmp-dictionary'
  "MyPlug 'andersevenrud/compe-tmux', {'branch': 'cmp'}
  MyPlug 'hrsh7th/cmp-vsnip'
  MyPlug 'hrsh7th/vim-vsnip'
endif

MyPlug 'lifepillar/vim-solarized8'
MyPlug 'joshdick/onedark.vim'

call MyPlugUpgrade()

