" global var {{{
let g:root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:config_dir = g:root_dir
let g:lsp_servers = ['pylsp', 'clangd', 'ccls']
let g:complete_engine = 'nvimlsp'

if filereadable(g:root_dir . '/basic.vim') == 0
  let g:config_dir = g:root_dir . '/..'
  exec 'set rtp^=' . g:config_dir
end

execute 'source ' . g:config_dir . '/basic.vim'
execute 'source ' . g:config_dir . '/plug.vim'
execute 'source ' . g:config_dir . '/common_plug.vim'
call MyPlugUpgrade()


"colors && load after {{{
let g:colorscheme = get(g:, 'colorscheme', 'onedark')
let g:background=get(g:, 'background', 'dark')

call ColorConfig()

call LoadAfterConfig()


