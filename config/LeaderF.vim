let g:Lf_ShortcutF = 'ff'
let g:Lf_DefaultMode = 'FullPath'
let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \}

nnoremap fb :<C-u>LeaderfBufferAll<CR>
nnoremap fl :<C-u>LeaderfLine<CR>
nnoremap fo :<C-u>LeaderfFunction<CR>
nnoremap ft :<C-u>LeaderfTag<CR>
nnoremap fm :<C-u>LeaderfMru<CR>
