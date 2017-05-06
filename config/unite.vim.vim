let g:unite_data_directory=g:config_dir . '/.cache/unite'
let g:unite_enable_start_insert=0
let g:unite_source_history_yank_enable = 1
let g:unite_force_overwrite_statusline=1

call unite#filters#matcher_default#use(['matcher_fuzzy'])

if g:os_windows
    if executable('ag')
        let g:unite_source_rec_async_command = [
        \ 'ag', '--follow', '--nocolor', '--nogroup', '--hidden',
        \ '--ignore','lib', '--ignore','obj', '--ignore','out',
        \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
        \ '--ignore','deploy',
        \ '-g', '']
    elseif executable('pt')
        let g:unite_source_rec_async_command = [
        \ 'pt', '--follow', '--nocolor', '--nogroup', '--hidden',
        \ '--ignore','lib', '--ignore','obj', '--ignore','out',
        \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
        \ '--ignore','deploy',
        \ '-g:', '']
    endif
endif

if executable('pt')
    if g:os_linux
        let g:unite_source_rec_async_command = [
        \ 'pt', '--follow', '--nocolor', '--nogroup', '--hidden',
        \ '--ignore','lib', '--ignore','obj', '--ignore','out',
        \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
        \ '--ignore','deploy',
        \ '-g', '']
    endif

    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts =
    \'--vimgrep --hidden --nocolor --nogroup
    \ --ignore ''.svn'' --ignore ''.git''
    \ --ignore ''lib'' --ignore ''obj'' --ignore ''out''
    \ --ignore ''tags'' --ignore ''GTAGS'' --ignore ''GRTAGS'' --ignore ''GPATH''
    \ --ignore ''deploy''
    \'
endif
let g:unite_source_grep_encoding = 'utf-8'

nnoremap [unite] <Nop>
nmap f [unite]
nmap <c-p> [unite]
"nnoremap <silent> [unite]s :<C-u>Unite source<CR>
nnoremap <silent> [unite]f :<C-u>Unite -silent -start-insert file_rec/async<CR>
nnoremap <silent> [unite]b :<C-u>Unite -start-insert buffer bookmark<CR>
nnoremap <silent> [unite]g :<C-u>Unite grep:.<CR>
nnoremap <silent> [unite]l :<C-u>Unite -start-insert line<CR>
nnoremap <silent> [unite]o :<C-u>Unite -start-insert outline<CR>
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]h :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]p :<C-u>Unite jump_point file_point<CR>
nnoremap <silent> [unite]r <Plug>(unite_redraw)

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
    let b:SuperTabDisabled=1
    imap <buffer> <C-j>     <Plug>(unite_select_next_line)
    nmap <buffer> <C-j>     <Plug>(unite_select_next_line)
    imap <buffer> <C-k>     <Plug>(unite_select_previous_line)
    nmap <buffer> <C-k>     <Plug>(unite_select_previous_line)
    
    imap <buffer> <TAB>     <Plug>(unite_select_next_line)
    imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
    imap <buffer> '         <Plug>(unite_quick_match_default_action)
    nmap <buffer> '         <Plug>(unite_quick_match_default_action) 
    imap <buffer><expr> x
            \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")    
    nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
    nmap <buffer> <C-p>     <Plug>(unite_toggle_auto_preview)
    imap <buffer> <C-p>     <Plug>(unite_toggle_auto_preview)
    nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
    nmap <buffer> <esc>     <plug>(unite_exit)
    imap <buffer> <esc>     <plug>(unite_exit)
endfunction
