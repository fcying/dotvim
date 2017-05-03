"let g:multi_cursor_next_key='<S-n>'
"let g:multi_cursor_prev_key='<S-p>'
"let g:multi_cursor_skip_key='<S-x>'
let g:multi_cursor_quit_key='<Esc>'
" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
    if exists(':NeoCompleteLock')==2
        exe 'NeoCompleteLock'
    endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
    if exists(':NeoCompleteUnlock')==2
        exe 'NeoCompleteUnlock'
    endif
endfunction
