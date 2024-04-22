local g, api = vim.g, vim.api
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
    require("config").gen_clang_conf(),
    require("config").suda(),
    { "wsdjeg/vim-fetch", lazy = false },
    { "ojroques/nvim-osc52", opts = { silent = true, trim = false } },
    {
        "mbbill/fencview",
        cmd = { "FencView", "FencAutoDetect" },
        config = function()
            g.fencview_autodetect = 0
            g.fencview_checklines = 10
        end,
    },
    { -- auto adjust 'shiftwidth' and 'expandtab'
        "tpope/vim-sleuth",
        event = "VeryLazy",
        config = function()
            --g.sleuth_make_heuristics = 0
            g.sleuth_heuristics = 0
        end,
    },
    require("config").lastplace(),
    --{ 'simnalamburt/vim-mundo', event = 'VimEnter' },

    -- editor {{{
    {
        "moll/vim-bbye",
        cmd = { "Bdelete", "Bclose" },
        keys = { { "<leader>q", "<cmd>Bdelete<CR>", desc = "Quit Buffer" } },
        config = function()
            vim.api.nvim_create_user_command("Bclose", "Bdelete", { bang = true })
        end
    },
    require("config").sandwich(),
    require("config").nerdcommenter(),
    require("config").window_picker(),
    --require("config").incline(),
    require("config").tagbar(),
    require("config").marks(),
    {
        "Yggdroot/indentLine",
        cmd = "IndentLinesToggle",
        keys = { { "<leader>i", "<cmd>IndentLinesToggle<CR>", desc = "IndentLinesToggle" } },
        config = function()
            g.indentLine_setColors = 1
            g.indentLine_enabled = 0
            g.indentLine_char_list = { "|", "¦", "┆", "┊" }
        end,
    },
    {
        "mg979/vim-visual-multi",
        event = "VeryLazy",
        config = function()
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
    --require("config").fern(),
    require("config").nvim_tree(),
    require("config").dashboard(),
    require("config").lualine(),
    require("plugins.telescope").lazy,
    { import = "plugins.colorscheme" },

    -- tool {{{
    { "chrisbra/Colorizer", cmd = { "ColorToggle" } },
    --require("config").noice(),
    require("config").nvim_notify(),
    require("config").ZFVimIM(),
    {
        "ZSaberLv0/ZFVimDirDiff",
        cmd = "ZFDirDiff",
        dependencies = "ZSaberLv0/ZFVimJob",
        config = function()
            g.ZFJobVerboseLogEnable = 0
            g.ZFDirDiffUI_showSameFile = 1
        end,
    },
    require("config").fugitive(),
    require("config").asynctasks(),
    require("config").whichkey(),

    -- coding {{{
    require("config").treesitter(),
    require("config").nt_textobjects(),
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
    require("lsp").guard(),
    {
        "neovim/nvim-lspconfig",
        config = require("lsp").setup,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            require("plugins.mason").setup(),
            { "folke/neodev.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
        },
    },
    require("config").cmp(),

    -- filetype {{{
    --{ 'kevinhwang91/nvim-bqf', ft = 'qf' },
    { "Vimjas/vim-python-pep8-indent", ft = "python" },
    { "peterhoeg/vim-qml", ft = "qml" }, --FIXME https://github.com/neovim/neovim/pull/24812 echo has("patch-9.0.1768")
    { "othree/xml.vim", ft = "xml" },
    { "wsdjeg/vim-autohotkey", ft = "autohotkey" },
    { "plasticboy/vim-markdown", ft = "markdown", dependencies = "godlygeek/tabular" },

    -- misc {{{
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
