local fn = vim.fn
local root_dir = fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')

local lazypath = root_dir .. "/plugged/lazy.nvim"
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
    root = root_dir .. "/plugged",
    lockfile = root_dir .. "/plugged/lazy-lock.json",
    state = root_dir .. "/plugged/state.json",
})

