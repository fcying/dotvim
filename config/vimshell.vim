nnoremap <leader>vs :silent VimShell<CR>
let g:vimshell_prompt_expr =
    \ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
let g:vimshell_no_default_keymappings=0
