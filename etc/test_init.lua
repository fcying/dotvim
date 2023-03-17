local g, fn = vim.g, vim.fn
g.config_dir = fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')
g.plug_dir = g.config_dir .. '/plugged'

local lazypath = g.plug_dir .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ 
    {"easymotion/vim-easymotion", event="VeryLazy"},
}, {
    root = g.plug_dir,
    lockfile = g.plug_dir .. "/lazy-lock.json",
    state = g.plug_dir .. "/state.json",
})

