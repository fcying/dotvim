"let g:ctrlsf_debug_mode = 1
"redir! > ctrlsf.log
let g:ctrlsf_ackprg = 'ag'
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_case_sensitive = 'smart'
let g:ctrlsf_ignore_dir = ['tags', 'GTAGS', 'GPATH', 'GRTAGS', 'obj', 'out', 'lib*']

nnoremap [CtrlSF] <Nop>
nmap <leader>s [CtrlSF]
vmap <leader>s [CtrlSF]
nmap [CtrlSF]f :CtrlSF<CR>
nmap [CtrlSF]i <Plug>CtrlSFPrompt
vmap [CtrlSF]f <Plug>CtrlSFVwordExec
vmap [CtrlSF]F <Plug>CtrlSFVwordPath
nmap [CtrlSF]c <Plug>CtrlSFCwordPath
nmap [CtrlSF]p <Plug>CtrlSFPwordPath
nmap [CtrlSF]l <Plug>CtrlSFQuickfixPrompt
vmap [CtrlSF]l <Plug>CtrlSFQuickfixVwordPath
vmap [CtrlSF]L <Plug>CtrlSFQuickfixVwordExec
nnoremap [CtrlSF]o :CtrlSFOpen<CR>
nnoremap [CtrlSF]t :CtrlSFToggle<CR>
inoremap [CtrlSF]t <Esc>:CtrlSFToggle<CR>

let g:ctrlsf_mapping = {
    \ "next"    : "<c-w>",
    \ "prev"    : "<c-e>",
    \ }

autocmd! FileType ctrlsf call s:ctrlsf_settings()
function! s:ctrlsf_settings()
    nmap <buffer> <c-j> <c-w>p
    nmap <buffer> <c-k> <c-e>p
endfunction