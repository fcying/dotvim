let g:Lf_CommandMap = {'<C-C>': ['<Esc>'],'<Esc>':['<C-I>']}
let g:Lf_ShortcutF = 'ff'
let g:Lf_ShortcutB = 'fb'
let g:Lf_PreviewCode = 0
let g:Lf_DefaultMode = 'FullPath'
let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \}

nnoremap fl :<C-u>LeaderfLine<CR>
nnoremap fo :<C-u>LeaderfFunction<CR>
nnoremap ft :<C-u>LeaderfTag<CR>
nnoremap fm :<C-u>LeaderfMru<CR>

"autocmd FileType leaderf call s:lf_my_settings()
function! s:lf_my_settings()
    map <buffer> <esc> :exec g:Lf_py "fileExplManager.quit()"<CR>
endfunction
