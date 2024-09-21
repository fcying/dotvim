local g = vim.g
local map = require("util").map

g.plug_dir = g.runtime_dir .. "/plugins"
local lazypath = g.plug_dir .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath })
end
vim.opt.rtp:prepend(lazypath)

map("n", "<leader>pu", ":Lazy update<CR>:RemoveLsplog<CR>")
map("n", "<leader>pr", ":Lazy clean<CR>")

local plugins = {
    -- misc {{{
    { import = "plugins.colorscheme" },
    { import = "plugins.suda" },
    { import = "plugins.mini" },
    { import = "plugins.misc" },

    -- editor {{{
    { import = "plugins.sleuth" },
    { import = "plugins.comment" },
    { import = "plugins.window_picker" },
    -- { import = "plugins.incline" },
    { import = "plugins.tagbar" },
    { import = "plugins.marks" },
    { import = "plugins.indentLine" },
    { import = "plugins.vim-visual-multi" },
    { import = "plugins.vim_expand_region" },
    { import = "plugins.flash" },
    { import = "plugins.foldsearch" },
    { import = "plugins.lualine" },

    -- tool {{{
    { import = "plugins.fern" },
    -- { import = "plugins.nvim_tree" },
    { import = "plugins.dashboard" },
    require("plugins.telescope").setup,
    -- { "Yggdroot/LeaderF", cmd = { "Leaderf" }, build = ":LeaderfInstallCExtension" },
    { "chrisbra/Colorizer", cmd = { "ColorToggle" } },
    { "fcying/vim-plugin-AnsiEsc", cmd = { "AnsiEsc", "AnsiEscClear" } },
    { "stevearc/dressing.nvim", opts = {} },
    -- { import = "plugins.noice" },
    { import = "plugins.nvim_notify" },
    { import = "plugins.ZFVimIM" },
    { import = "plugins.ZFVimDirDiff" },
    { import = "plugins.fugitive" },
    { import = "plugins.toggleterm" },
    require("plugins.asynctasks").setup,
    -- { import = "plugins.overseer" },
    { import = "plugins.whichkey" },

    -- filetype {{{
    --{ 'kevinhwang91/nvim-bqf', ft = 'qf' },
    { "Vimjas/vim-python-pep8-indent", ft = "python" },
    { "wsdjeg/vim-autohotkey", ft = "autohotkey" },

    -- coding {{{
    { import = "plugins.gen_clang_conf" },
    { import = "plugins.conform" },
    { import = "plugins.todo-comments" },
    { import = "plugins.lazydev" },
    { import = "plugins.cmp" },
    { import = "plugins.treesitter" },
    {
        "neovim/nvim-lspconfig",
        config = require("lsp").setup,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { import = "plugins.lspzero" },
            { import = "plugins.mason" },
            { "williamboman/mason-lspconfig.nvim" },
        },
    },
}

-- lazy config {{{
require("lazy").setup(plugins, {
    root = g.plug_dir,
    checker = {
        enabled = false,
        notify = true,
        frequency = 3600 * 12,
        check_pinned = false,
    },
    defaults = {
        lazy = false,
        version = nil,
        --version = "*", --try installing the latest stable versions of plugins
    },
    performance = {
        cache = { enabled = true },
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            reset = true,
            paths = { g.config_dir },
            disabled_plugins = {
                --"matchit",
                --"matchparen",
                "gzip",
                "netrw",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    install = {
        missing = true,
        colorscheme = { "solarized", "habamax" },
    },
    ui = {
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})
