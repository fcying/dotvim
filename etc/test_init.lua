local g, fn = vim.g, vim.fn
g.config_dir = fn.fnamemodify(fn.resolve(fn.expand('<sfile>:p')), ':h')
g.runtime_dir = g.config_dir .. "/.repro"
for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = g.runtime_dir .. "/" .. name
end

local lazypath = g.runtime_dir .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--single-branch",
        "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.runtimepath:prepend(lazypath)
vim.opt.termguicolors = true

local plugins = {
    { "maxmx03/solarized.nvim" },
    -- test plugins
}

require("lazy").setup(plugins, {
    root = g.runtime_dir .. "/plugins",
})
vim.opt.background = "light"
vim.cmd.colorscheme("solarized")
