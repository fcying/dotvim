"start gocode first
function! s:fcy_CallGocode()
    if !exists('g:startGocode')
        call vimproc#system_bg('gocode')
        let g:startGocode = 1
    endif
endfunction
autocmd! VimEnter *.go call s:fcy_CallGocode()

"let g:gocomplete#system_function = 'vimproc#system'
let g:godef_split=0
let g:godef_same_file_in_same_window=1