let tagbar_left=1
nnoremap <silent><Leader>tt :TagbarToggle<CR>
nnoremap <silent><F11> :TagbarToggle<CR>
let tagbar_width=32
let g:tagbar_compact=1
"autocmd FileType c,cpp,h nested :TagbarOpen
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