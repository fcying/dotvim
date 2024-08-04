local g = vim.g
local util = require("util")
local map = require("util").map

g.plug_dir = g.runtime_dir .. "/plugins"
local lazypath = g.plug_dir .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath })
end
vim.opt.rtp:prepend(lazypath)

map("n", "<leader>pu", ":Lazy update<CR>")
map("n", "<leader>pr", ":Lazy clean<CR>")

local plugins = {
    -- misc {{{
    { import = "plugins.colorscheme" },
    require("config").suda(),
    require("config").mini(),
    { "wsdjeg/vim-fetch", lazy = false },
    { "ojroques/nvim-osc52", opts = { silent = true, trim = false } },
    {
        "mbbill/fencview",
        cmd = { "FencView", "FencAutoDetect" },
        init = function()
            g.fencview_autodetect = 0
            g.fencview_checklines = 10
        end,
    },
    { -- auto adjust 'shiftwidth' and 'expandtab'
        "tpope/vim-sleuth",
        init = function()
            --g.sleuth_make_heuristics = 0
            g.sleuth_heuristics = 0
            g.sleuth_vue_heuristics = 1
        end,
    },
    require("config").lastplace(),
    --{ 'simnalamburt/vim-mundo', event = 'VimEnter' },

    -- editor {{{
    require("config").Comment(),
    require("config").window_picker(),
    --require("config").incline(),
    require("config").tagbar(),
    require("config").marks(),
    {
        "Yggdroot/indentLine",
        cmd = "IndentLinesToggle",
        keys = { { "<leader>i", "<cmd>IndentLinesToggle<CR>", desc = "IndentLinesToggle" } },
        init = function()
            g.indentLine_setColors = 1
            g.indentLine_enabled = 0
            g.indentLine_char_list = { "|", "¦", "┆", "┊" }
        end,
    },
    {
        "mg979/vim-visual-multi",
        event = "VeryLazy",
        init = function()
            vim.cmd([[
                let g:VM_maps = {}
                let g:VM_maps['Find Under']         = '<C-n>'
                let g:VM_maps['Find Subword Under'] = '<C-n>'
                let g:VM_cmdheight = 1
            ]])
        end,
    },
    --{ "andymass/vim-matchup", event = "VimEnter" },
    require("config").vim_expand_region(),
    --require("config").leap(),
    require("config").flash(),
    require("config").foldsearch(),
    require("config").fern(),
    -- require("config").nvim_tree(),
    require("config").dashboard(),
    require("config").lualine(),
    require("plugins._telescope").lazy,
    -- { "Yggdroot/LeaderF", cmd = { "Leaderf" }, build = ":LeaderfInstallCExtension" },

    -- tool {{{
    { "chrisbra/Colorizer", cmd = { "ColorToggle" } },
    { "fcying/vim-plugin-AnsiEsc", cmd = { "AnsiEsc", "AnsiEscClear" } },
    { "stevearc/dressing.nvim", opts = {} },
    --require("config").noice(),
    require("config").nvim_notify(),
    require("config").ZFVimIM(),
    {
        "ZSaberLv0/ZFVimDirDiff",
        cmd = "ZFDirDiff",
        dependencies = "ZSaberLv0/ZFVimJob",
        init = function()
            g.ZFJobVerboseLogEnable = 0
            g.ZFDirDiffUI_showSameFile = 1
        end,
    },
    require("config").fugitive(),
    require("config").toggleterm(),
    require("config").asynctasks(),
    -- require("config").overseer(),
    require("config").whichkey(),

    -- coding {{{
    require("config").gen_clang_conf(),
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                "luvit-meta/library",
                g.config_dir .. "/lua",
            },
            enabled = function(_)
                if vim.g.lazydev_enabled ~= nil then
                    return vim.g.lazydev_enabled
                end
                local filename = vim.fn.expand("%:t")
                if filename == ".nvim.lua" or vim.uv.fs_stat(util.root_dir .. "/lua") then
                    return true
                else
                    return false
                end
            end,
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    require("config").treesitter(),
    require("config").nt_cpp_tools(),
    --require("lsp").null_ls(),
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
            vim.g.lsp_zero_ui_float_border = 0
        end,
    },
    require("lsp").conform(),
    {
        "neovim/nvim-lspconfig",
        config = require("lsp").setup,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            require("config").mason(),
            { "williamboman/mason-lspconfig.nvim" },
        },
    },
    require("config").cmp(),

    -- filetype {{{
    --{ 'kevinhwang91/nvim-bqf', ft = 'qf' },
    { "Vimjas/vim-python-pep8-indent", ft = "python" },
    { "wsdjeg/vim-autohotkey", ft = "autohotkey" },
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
