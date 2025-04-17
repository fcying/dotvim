vim.g.mapleader = " "
vim.g.config_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("<sfile>:p")), ":h")
vim.g.runtime_dir = vim.g.config_dir .. "/.repro"
for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = vim.g.runtime_dir .. "/" .. name
end

local lazypath = vim.g.runtime_dir .. "/plugins/lazy.nvim"
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
    root = vim.g.runtime_dir .. "/plugins",
})
vim.opt.background = "light"
vim.cmd.colorscheme("solarized")
