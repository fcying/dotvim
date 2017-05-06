call denite#custom#var('file_rec', 'command',
	\ ['pt', '--follow', '--nocolor', '--nogroup', '-g', ''])
    
call denite#custom#var('grep', 'command', ['pt'])
call denite#custom#var('grep', 'default_opts',
        \ ['--nogroup', '--nocolor', '--smart-case'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

call denite#custom#source('file_mru', 'converters',
      \ ['converter_relative_word'])
    
" Change matchers.
call denite#custom#source(
\ 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
"call denite#custom#source(
"\ 'file_rec', 'matchers', ['matcher_cpsm'])

" Change sorters.
call denite#custom#source(
\ 'file_rec', 'sorters', ['sorter_sublime'])      

nnoremap [Denite] <Nop>
nmap f [Denite]
nmap <c-p> [Denite]
nnoremap <silent> [Denite]f :<C-u>Denite file_rec<CR>
nnoremap <silent> [Denite]b :<C-u>Denite buffer bookmark<CR>
nnoremap <silent> [Denite]g :<C-u>Denite grep:.<CR>
nnoremap <silent> [Denite]l :<C-u>Denite line<CR>
nnoremap <silent> [Denite]o :<C-u>Denite outline<CR>
nnoremap <silent> [Denite]y :<C-u>Denite history/yank<CR>
nnoremap <silent> [Denite]h :<C-u>Denite file_mru<CR>
nnoremap <silent> [Denite]p :<C-u>Denite jump_point file_point<CR>
nnoremap <silent> [Denite]r <Plug>(unite_redraw)  
"nnoremap <silent> [Denite]s :<C-u>Denite source<CR>

call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<Esc>',
      \ '<denite:quit>',
      \ 'noremap'
      \)
      
