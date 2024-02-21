local g, api = vim.g, vim.api
local map = require("util").map
local config = require("util").config

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
    { "fcying/gen_clang_conf.vim", lazy = false },
    { "wsdjeg/vim-fetch", lazy = false },
    { "ojroques/nvim-osc52", opts = { silent = true, trim = false } },
    {
        "lambdalisue/suda.vim",
        cmd = { "SudoRead", "SudoWrite" },
        config = function()
            api.nvim_create_user_command("SudoRead", "SudaRead", {})
            api.nvim_create_user_command("SudoWrite", "SudaWrite", {})
        end,
    },
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
    { "ethanholz/nvim-lastplace", lazy = false, config = config("lastplace") },
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
    { "preservim/nerdcommenter", event = "VeryLazy" },
    { "machakann/vim-sandwich", event = "VeryLazy", config = config("sandwich") },
    {
        "t9md/vim-choosewin",
        keys = { { "-", "<Plug>(choosewin)", desc = "choosewin" } },
    },
    { "preservim/tagbar", cmd = "TagbarToggle", config = config("tagbar") },
    { "chentoast/marks.nvim", event = "VimEnter", config = config("marks") },
    {
        "Yggdroot/indentLine",
        cmd = "IndentLinesToggle",
        config = function()
            g.indentLine_setColors = 1
            g.indentLine_enabled = 0
            g.indentLine_char_list = { "|", "¦", "┆", "┊" }
            map("n", "<leader>i", ":IndentLinesToggle<CR>", { silent = true })
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
    { "terryma/vim-expand-region", event = "VimEnter", config = config("vim_expand_region") },
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        dependencies = "tpope/vim-repeat",
        config = function()
            vim.keymap.set({ "n", "v" }, "s", function()
                local current_window = vim.fn.win_getid()
                require("leap").leap { target_windows = { current_window } }
            end)
        end
    },
    {
        "fcying/vim-foldsearch",
        cmd = { "Fp", "Fw", "Fs", "FS", "Fl", "Fi", "Fd", "Fe" },
    },
    {
        "lambdalisue/fern.vim",
        cmd = "Fern",
        keys = {
            { "<leader>wf", "<cmd>Fern . -drawer -toggle -keep<CR>", desc = "file explorer" },
            { "<leader>wl", "<cmd>Fern . -drawer -reveal=%<CR>", desc = "file location" },
        },
        config = config("fern"),
    },
    { import = "plugins.telescope" },

    -- tool {{{
    { "rcarriga/nvim-notify", config = config("notify") },
    --require("config").noice(),
    { "chrisbra/Colorizer", cmd = { "ColorToggle" } },
    {
        "ZSaberLv0/ZFVimIM",
        event = "VeryLazy",
        dependencies = { "ZSaberLv0/ZFVimJob", "fcying/ZFVimIM_wubi_jidian" },
    },
    {
        "ZSaberLv0/ZFVimDirDiff",
        cmd = "ZFDirDiff",
        dependencies = "ZSaberLv0/ZFVimJob",
        config = function()
            g.ZFJobVerboseLogEnable = 0
            g.ZFDirDiffUI_showSameFile = 1
        end,
    },
    {
        "rbong/vim-flog",
        cmd = { "Flog", "Flogsplit", "Floggit" },
        dependencies = { "tpope/vim-fugitive", event = "VeryLazy", config = config("fugitive") },
    },
    { "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } },
    { "skywind3000/asynctasks.vim", cmd = { "AsyncTask", "AsyncTaskMacro", "AsyncTaskList", "AsyncTaskEdit" } },
    { "folke/which-key.nvim", event = "VeryLazy", config = config("whichkey") },

    -- coding {{{
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        config = config("treesitter"),
        build = ":TSUpdate",
    },
    {
        "Badhi/nvim-treesitter-cpp-tools",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = config("nt_cpp_tools"),
    },
    --{
    --    "nvimtools/none-ls.nvim",
    --    event = { "BufReadPre", "BufNewFile" },
    --    dependencies = {
    --        "nvim-lua/plenary.nvim",
    --        "neovim/nvim-lspconfig",
    --    },
    --    config = config("null_ls", "lsp"),
    --},
    {
        "nvimdev/guard.nvim",
        cmd = "GuardFmt", -- broken auto format
        config = config("guard", "lsp"),
    },
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
    {
        "neovim/nvim-lspconfig",
        config = config("setup", "lsp"),
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            require("plugins.mason").setup(),
            { "folke/neodev.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        config = config("cmp"),
        version = false, -- last release is way too old
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            {
                "L3MON4D3/LuaSnip",
                build = (g.is_win == 0) and g.make .. " install_jsregexp" or nil,
                config = config("luasnip"),
                dependencies = { "rafamadriz/friendly-snippets" }
            },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-cmdline" },
            { "dmitmel/cmp-cmdline-history" },
            { "hrsh7th/cmp-omni" },
            { "quangnguyen30192/cmp-nvim-tags" },
            { "uga-rosa/cmp-dictionary", config = config("cmp_dictionary") },
        },
    },

    -- colorscheme {{{
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        dependencies = { { "nvim-tree/nvim-web-devicons" } },
        config = config("dashboard"),
    },
    { "nvim-lualine/lualine.nvim", event = "ColorScheme", config = config("lualine") },
    { "maxmx03/solarized.nvim", lazy = false, priority = 1000 },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

    -- filetype {{{
    --{ 'kevinhwang91/nvim-bqf', ft = 'qf' },
    { "Vimjas/vim-python-pep8-indent", ft = "python" },
    { "cespare/vim-toml", ft = "toml" },
    { "peterhoeg/vim-qml", ft = "qml" }, --FIXME https://github.com/neovim/neovim/pull/24812 echo has("patch-9.0.1768")
    { "neoclide/jsonc.vim", ft = "jsonc" },
    { "othree/xml.vim", ft = "xml" },
    { "wsdjeg/vim-autohotkey", ft = "autohotkey" },
    { "plasticboy/vim-markdown", ft = "markdown", dependencies = "godlygeek/tabular" },
}

-- lazy config {{{
require("lazy").setup(plugins, {
    root = g.plug_dir,
    checker = {
        enabled = true,
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
                "gzip",
                --"matchit",
                --"matchparen",
                --"netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    install = {
        missing = true,
        colorscheme = { "solarized8", "desert" },
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
