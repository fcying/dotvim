if (HasPlug('gen_clang_conf.vim') != -1) "{{{
  let g:gencconf_storein_rootmarker = get(g:,'gencconf_storein_rootmarker',1)
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

if (HasPlug('vim-bbye') != -1) "{{{
  nnoremap <Leader>q :Bdelete<CR>
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

if (HasPlug('vim-foldsearch') != -1) "{{{
  let g:foldsearch_highlight = 1

  nmap <Leader>fp :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
  xmap <Leader>fp :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
endif "}}}

if (HasPlug('vim-vsnip') != -1) "{{{
  let g:vsnip_snippet_dir = g:root_dir . '/snippets'
  imap <expr> <c-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-j>'
  smap <expr> <c-j> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-j>'
  imap <expr> <c-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-k>'
  smap <expr> <c-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-k>'
endif "}}}

if (HasPlug('vim-fugitive') != -1) "{{{
  autocmd myau FileType fugitive* nmap <buffer> q gq
  autocmd myau FileType git nmap <buffer> q :q<CR>
  "autocmd myau FileType floggraph nmap <buffer> q <c-w>lq
endif "}}}

if (HasPlug('vim-grepper') != -1) "{{{
  let g:grepper           = {}
  let g:grepper.tools     = ['rg', 'git', 'grep', 'findstr']
  let g:grepper.rg        = { 'grepprg': 'rg --no-config -H --vimgrep --no-heading' }
  let g:grepper.git       = { 'grepprg': 'git grep -nI' }
  let g:grepper.grep      = { 'grepprg': 'grep -rn --exclude-dir=.git --exclude-dir=.root --exclude-dir=.repo' }
  let g:grepper.repo      = ['.root', '.git', '.hg', '.svn']
  let g:grepper.dir       = 'repo,file'
  let g:grepper.jump      = 0
  let g:grepper.prompt    = 0
  let g:grepper.searchreg = 1
  aug Grepper
    au!
    au User Grepper ++nested call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})
  aug END
  nmap gs  <plug>(GrepperOperator)
  xmap gs  <plug>(GrepperOperator)
endif "}}}

if (HasPlug('lightline.vim') != -1) "{{{
  set showtabline=1
  let g:lightline = {}
  let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }
endif "}}}

if (HasPlug('vim-visual-multi') != -1) "{{{
  let g:VM_no_meta_mappings = 1
  let g:VM_maps = {}
  let g:VM_maps['Find Under']         = '<C-n>'
  let g:VM_maps['Find Subword Under'] = '<C-n>'
  let g:VM_cmdheight = 1
  "let g:VM_manual_infoline = 1
endif "}}}

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
  let g:coc_config_home = g:root_dir
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
  nmap <silent> <leader>lt <Plug>(coc-type-definition)
  nmap <silent> <leader>li <Plug>(coc-implementation)
  nmap <silent> <leader>lr <Plug>(coc-references)

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
  let g:templates_directory = g:root_dir . '/template'
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

if (HasPlug('telescope.nvim') != -1) "{{{
  lua require('config').telescope_map()
  "lua require('config').telescope()
endif

if (HasPlug('nvim-lspconfig') != -1) "{{{
  lua require('config').lspconfig()
endif
