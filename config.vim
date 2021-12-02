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
  let g:foldsearch_disable_mappings = 1
  let g:foldsearch_highlight = 1

  nmap <Leader>fp :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
  xmap <Leader>fp :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
  map <Leader>fw :call foldsearch#foldsearch#FoldCword()<CR>
  map <Leader>fs :call foldsearch#foldsearch#FoldSearch()<CR>
  map <Leader>fS :call foldsearch#foldsearch#FoldSpell()<CR>
  map <Leader>fl :call foldsearch#foldsearch#FoldLast()<CR>
  map <Leader>fi :call foldsearch#foldsearch#FoldContextAdd(+1)<CR>
  map <Leader>fd :call foldsearch#foldsearch#FoldContextAdd(-1)<CR>
  map <Leader>fe :call foldsearch#foldsearch#FoldSearchEnd()<CR>
endif "}}}

if (HasPlug('vim-vsnip') != -1) "{{{
  let g:vsnip_snippet_dir = g:config_dir . '/snippets'
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
  let g:grepper         = {}
  let g:grepper.tools   = ['rg', 'git', 'grep', 'findstr']
  let g:grepper.rg      = { 'grepprg': 'rg --no-config -H --vimgrep --no-heading' }
  let g:grepper.git     = { 'grepprg': 'git grep -nI' }
  let g:grepper.grep    = { 'grepprg': 'grep -rn --exclude-dir=.git --exclude-dir=.root --exclude-dir=.repo' }
  let g:grepper.repo    = ['.root', '.git', '.hg', '.svn']
  let g:grepper.dir     = 'repo,file'
  let g:grepper.jump    = 0
  let g:grepper.prompt  = 0
  nnoremap <leader>* :Grepper -cword<cr>
  xnoremap <leader>* :<C-u><C-R>=printf("Grepper -query %s", GetVisualSelection())<CR>
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
