local fn, cmd = vim.fn, vim.cmd
local root_dir = fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')

cmd('set packpath=' .. root_dir .. '/plugged')
cmd('set runtimepath^=' .. root_dir .. '/plugged')
local install_path = root_dir .. '/plugged/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    Bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

cmd([[
    set mouse=n
    packadd packer.nvim
    nnoremap <space>pu :PackerSync<CR>
    nnoremap <space>pc :PackerCompile<CR>
]])

local packer = require('packer')
local use = packer.use
packer.init({
    package_root = root_dir .. '/plugged/pack',
    compile_path  = root_dir .. '/plugged/plugin/packer_compiled.lua',
})

use {'wbthomason/packer.nvim', opt = true}
use 'lifepillar/vim-solarized8'

if Bootstrap then
    packer.sync()
end

cmd [[
    set termguicolors
    colorscheme solarized8
    set background=light
]]
