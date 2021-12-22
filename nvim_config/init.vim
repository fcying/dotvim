" global var {{{
let g:root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:config_dir = g:root_dir

if filereadable(g:root_dir . '/basic.vim') == 0
  let g:config_dir = fnamemodify(g:root_dir, ':h')
  exec 'set rtp^=' . g:config_dir
end

execute 'source ' . g:config_dir . '/basic.vim'

call extend(g:lsp_servers, ['clangd', 'ccls'])

execute 'source ' . g:config_dir . '/plug.vim'
call MyPlugUpgrade()

"colors && load after {{{
let g:colorscheme = get(g:, 'colorscheme', 'onedark')

call ColorConfig()

call LoadAfterConfig()


