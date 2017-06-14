if executable('rg')
    call denite#custom#var('grep', 'command', ['rg'])
	call denite#custom#var('file_rec', 'command',
        \ ['rg', '--files', '--hidden', '--follow',
        \ '-g','!out', '-g','!obj', '-g', '!deploy',
        \ '-g','!tags', '-g','!GTAGS', '-g','!GRTAGS', '-g','!GPATH',
        \ '-g', '!.git', '-g', '!.svn'])
    call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
elseif executable('pt')
    call denite#custom#var('grep', 'command', ['pt'])
    call denite#custom#var('file_rec', 'command',
        \ ['pt', '--follow', '--nocolor', '--nogroup', '--hidden',
        \ '--ignore','lib', '--ignore','obj', '--ignore','out',
        \ '--ignore','deploy',
        \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
        \ '--ignore','.git', '--ignore','.svn', '-g', ''])
    call denite#custom#var('grep', 'default_opts',
        \ ['--nogroup', '--nocolor', '--smart-case', '--hidden',
        \ '--ignore','lib', '--ignore','obj', '--ignore','out',
        \ '--ignore','deploy',
        \ '--ignore','tags', '--ignore','GTAGS', '--ignore','GRTAGS', '--ignore','GPATH',
        \ '--ignore','.git', '--ignore','.svn'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
endif

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \ 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

call denite#custom#source('file_mru', 'converters',
    \ ['converter_relative_word'])
    
" Change matchers.
call denite#custom#source('file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
"call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])

" Change sorters.
call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])  

nnoremap [Denite] <Nop>
nmap f [Denite]
nmap <c-p> [Denite]
nnoremap [Denite]f :<C-u>Denite file_rec<CR>
"nnoremap [Denite]f :<C-u>FZF<CR>
nnoremap [Denite]F :<C-u>Denite file_rec
nnoremap [Denite]b :<C-u>Denite buffer bookmark<CR>
nnoremap [Denite]g :<C-u>Denite grep:.<CR>
nnoremap [Denite]l :<C-u>Denite line<CR>
nnoremap [Denite]o :<C-u>Denite outline<CR>
nnoremap [Denite]h :<C-u>Denite history/yank<CR>
nnoremap [Denite]m :<C-u>Denite file_mru<CR>
nnoremap [Denite]p :<C-u>Denite jump_point file_point<CR>
"nnoremap [Denite]s :<C-u>Denite source<CR>

" KEY MAPPINGS
let s:insert_mode_mappings = [
        \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
        \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
        \ ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
        \ ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
        \ ['<C-t>', '<denite:move_to_first_line>', 'noremap'],
        \ ['<C-b>', '<denite:move_to_last_line>', 'noremap'],
        \ ]

let s:normal_mode_mappings = [
        \ ["'", '<denite:toggle_select_down>', 'noremap'],
        \ ['<C-t>', '<denite:move_to_first_line>', 'noremap'],
        \ ['<C-b>', '<denite:move_to_last_line>', 'noremap'],
        \ ['st', '<denite:do_action:tabopen>', 'noremap'],
        \ ['sh', '<denite:do_action:vsplit>', 'noremap'],
        \ ['sv', '<denite:do_action:split>', 'noremap'],
        \ ]

for s:m in s:insert_mode_mappings
    call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
endfor
for s:m in s:normal_mode_mappings
    call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
endfor

unlet s:m s:insert_mode_mappings s:normal_mode_mappings
