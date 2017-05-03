let g:NERDCreateDefaultMappings = 0
let g:NERDRemoveExtraSpaces = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = {
            \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
            \ 'cpp': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
            \ 'go': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
            \ 'qml': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
            \ 'conf': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '#' },
            \ }
nmap <A-/> <plug>NERDCommenterToggle
vmap <A-/> <plug>NERDCommenterToggle gv
nmap <leader>cc <plug>NERDCommenterToggle
vmap <leader>cc <plug>NERDCommenterToggle gv
