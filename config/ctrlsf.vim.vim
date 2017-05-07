"let g:ctrlsf_debug_mode = 1
"redir! > ctrlsf.log
let g:ctrlsf_ackprg = 'ag'
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_case_sensitive = 'smart'
let g:ctrlsf_ignore_dir = ['tags', 'GTAGS', 'GPATH', 'GRTAGS', 'obj', 'out', 'lib*']

nmap <leader>sf <Plug>CtrlSFCwordExec
nmap <leader>sF <Plug>CtrlSFPrompt
vmap <leader>sf <Plug>CtrlSFVwordExec
vmap <leader>sF <Plug>CtrlSFVwordPath
nmap <leader>sp <Plug>CtrlSFPwordPath
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>
inoremap <leader>st <Esc>:CtrlSFToggle<CR>

let g:ctrlsf_mapping = {
    \ "next"    : "<c-w>",
    \ "prev"    : "<c-e>",
    \ }

autocmd! FileType ctrlsf call s:ctrlsf_settings()
function! s:ctrlsf_settings()
    nmap <buffer> <c-j> <c-w>p
    nmap <buffer> <c-k> <c-e>p
endfunction
