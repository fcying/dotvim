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
    { import = "plugins.multicursor" },
    { import = "plugins.vim_expand_region" },
    -- { import = "plugins.flash" },
    { import = "plugins.hop" },
    { import = "plugins.foldsearch" },
    { import = "plugins.lualine" },

    -- tool {{{
    -- { import = "plugins.fern" },
    -- { import = "plugins.nvim_tree" },
    -- { import = "plugins.dashboard" },
    require("plugins.telescope").setup,
    require("plugins.snacks").setup,
    { import = "plugins.action_preview" },
    -- { "Yggdroot/LeaderF", cmd = { "Leaderf" }, build = ":LeaderfInstallCExtension" },
    { "chrisbra/Colorizer", cmd = { "ColorToggle" } },
    -- { import = "plugins.baleia" },

    { "fcying/vim-plugin-AnsiEsc", cmd = { "AnsiEsc", "AnsiEscClear" } },
    -- { import = "plugins.noice" },
    -- { import = "plugins.nvim_notify" },
    -- { import = "plugins.ZFVimIM" },
    -- { import = "plugins.ZFVimDirDiff" },
    { import = "plugins.fugitive" },
    { import = "plugins.toggleterm" },
    { import = "plugins.asynctasks" },
    { import = "plugins.just" },
    -- { import = "plugins.overseer" },
    { import = "plugins.whichkey" },
    { import = "plugins.stickybuf" },
    -- { import = "plugins.quicker" },
    { 'kevinhwang91/nvim-bqf', ft = 'qf' },
    -- { import = "plugins.nvim-ufo" },

    -- filetype {{{
    { import = "plugins.markview" },
    { "Vimjas/vim-python-pep8-indent", ft = "python" },
    { "wsdjeg/vim-autohotkey", ft = "autohotkey" },
    { "elkasztano/nushell-syntax-vim", ft = "nu" },

    -- coding {{{
    { import = "plugins.gen_clang_conf" },
    { import = "plugins.conform" },
    { import = "plugins.grug_far" },
    { import = "plugins.todo-comments" },
    { import = "plugins.lazydev" },
    { import = "plugins.xmake" },
    { import = vim.g.complete_engine == "cmp" and "plugins.cmp" or "plugins.blink" },
    { import = "plugins.treesitter" },
    -- { import = "plugins.tiny_inline_diagnostic" },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart", "LspRestart" },
        event = { "BufReadPre", "BufNewFile" },
        config = require("lsp").setup,
        dependencies = {
            { import = "plugins.mason" },
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
