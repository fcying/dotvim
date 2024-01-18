local g, fn = vim.g, vim.fn
g.config_dir = fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')
g.runtime_dir = g.config_dir .. "/.run"
for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = g.runtime_dir .. "/" .. name
end

local lazypath = g.config_dir .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", -- latest stable release
        "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            g.startuptime_tries = 5
        end,
    },
}

require("lazy").setup(plugins, {
    root = g.config_dir .. "/plugins",
})

vim.cmd.colorscheme("zellner")
