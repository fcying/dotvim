let g:root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
execute 'source ' . g:root_dir . '/init.lua'
