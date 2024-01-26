local g, api = vim.g, vim.api
local map = require("util").map

local lazypath = g.runtime_dir .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath })
end
vim.opt.rtp:prepend(lazypath)

map("n", "<leader>pu", ":Lazy update<CR>")
map("n", "<leader>pr", ":Lazy clean<CR>")

local function config(name, module)
    return function()
        if module == nil then
            require("config")[name]()
        else
            require(module)[name]()
        end
    end
end

local plugins = {
    { "fcying/gen_clang_conf.vim", lazy = false },
    { "wsdjeg/vim-fetch", lazy = false },
    { "ojroques/nvim-osc52", opts = { silent = true, trim = false } },
    { "lambdalisue/suda.vim", cmd = { "SudoRead", "SudoWrite" },
        config = function()
            api.nvim_create_user_command("SudoRead", "SudaRead", {})
            api.nvim_create_user_command("SudoWrite", "SudaWrite", {})
        end,
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            g.startuptime_tries = 5
        end,
    },
    { "mbbill/fencview", cmd = { "FencView", "FencAutoDetect" } },
    --{ 'simnalamburt/vim-mundo', event = 'VimEnter' },
    --{ 'mhinz/vim-grepper', cmd = { "Grepper", "<plug>(GrepperOperator)" } },
    { "tpope/vim-sleuth", event = "VeryLazy" }, -- auto adjust 'shiftwidth' and 'expandtab'
    { "ethanholz/nvim-lastplace", lazy = false, config = config("lastplace") },

    -- editor {{{
    {
        "moll/vim-bbye",
        cmd = "Bdelete",
        keys = { { "<leader>q", "<cmd>Bdelete<CR>", desc = "Quit Buffer" } },
        config = function()
            vim.cmd([[ command! -bang -nargs=0 Bclose exec 'Bdelete' ]])
            vim.api.nvim_create_user_command("Bclose", "Bdelete", {})
        end
    },
    { "preservim/nerdcommenter", event = "VeryLazy" },
    { "machakann/vim-sandwich", event = "VeryLazy" },
    {
        "t9md/vim-choosewin",
        keys = { { "-", "<Plug>(choosewin)", desc = "choosewin" } },
    },
    { "preservim/tagbar", cmd = "TagbarToggle" },
    { "Yggdroot/indentLine", cmd = "IndentLinesToggle" },
    { "chentoast/marks.nvim", event = "VimEnter", config = config("marks") },
    { "mg979/vim-visual-multi", event = "VimEnter" },
    --{ "andymass/vim-matchup", event = "VimEnter" },
    { "terryma/vim-expand-region", event = "VimEnter", config = config("vim_expand_region") },
    {
        "ggandor/leap.nvim", event = "VeryLazy",
        dependencies = "tpope/vim-repeat",
        config = function()
            vim.keymap.set({ "n", "v" }, "s", function()
                local current_window = vim.fn.win_getid()
                require('leap').leap { target_windows = { current_window } }
            end)
        end
    },
    {
        "fcying/vim-foldsearch",
        cmd = { "Fp", "Fw", "Fs", "FS", "Fl", "Fi", "Fd", "Fe" },
    },
    {
        'lambdalisue/fern.vim',
        cmd = 'Fern',
        keys = {
            { "<leader>wf", "<cmd>Fern . -drawer -toggle -keep<CR>", desc = "file explorer" },
            { "<leader>wl", "<cmd>Fern . -drawer -reveal=%<CR>", desc = "file location" },
        },
        config = config("fern"),
    },
    { import = "plugins.telescope" },

    -- tool {{{
    { "rcarriga/nvim-notify", event = "VimEnter", config = config("notify") },
    { "chrisbra/Colorizer", event = "VimEnter" },
    { "ZSaberLv0/ZFVimDirDiff", cmd = "ZFDirDiff", dependencies = "ZSaberLv0/ZFVimJob" },
    { "iberianpig/tig-explorer.vim", event = "VimEnter" },
    { "tpope/vim-fugitive", event = "VeryLazy" },
    { "rbong/vim-flog", cmd = { "Flog", "Flogsplit", "Floggit" } },
    { "skywind3000/asyncrun.vim", cmd = { "AsyncRun", "AsyncStop" } },
    { "skywind3000/asynctasks.vim", cmd = { "AsyncTask", "AsyncTaskMacro", "AsyncTaskList", "AsyncTaskEdit" } },
    { "folke/which-key.nvim", event = "VimEnter", config = config("whichkey") },

    -- coding {{{
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        config = config("treesitter"),
        build = ":TSUpdate",
    },
    {
        "Badhi/nvim-treesitter-cpp-tools",
        dependencies = {"nvim-treesitter/nvim-treesitter"},
        config = config("nt_cpp_tools"),
    },
    --{
    --    "jose-elias-alvarez/null-ls.nvim",
    --    event = { "BufReadPre", "BufNewFile" },
    --    dependencies = {
    --        "nvim-lua/plenary.nvim",
    --        "neovim/nvim-lspconfig",
    --    },
    --    config = config("null_ls", "lsp"),
    --},
    {
        "nvimdev/guard.nvim",
        cmd = "GuardFmt",     -- broken auto format
        config = config("guard"),
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
            { "folke/neodev.nvim" },
            { "williamboman/mason.nvim", lazy = false, build = ":MasonUpdate", config = config("mason") },
            { "williamboman/mason-lspconfig.nvim" },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
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
            { "hrsh7th/cmp-omni" },
            { "quangnguyen30192/cmp-nvim-tags" },
            { "uga-rosa/cmp-dictionary", commit="d17bc1f87736b6a7f058b2f246e651d34d648b47" },
        },
    },

    -- colorscheme {{{
    { "nvim-lualine/lualine.nvim", event = "ColorScheme", config = config("lualine") },
    { "lifepillar/vim-solarized8", lazy = true },
    { "tomasr/molokai", lazy = true },
    { "sainnhe/everforest", lazy = true },

    -- filetype {{{
    --{ 'kevinhwang91/nvim-bqf', ft = 'qf' },
    { "Vimjas/vim-python-pep8-indent", ft = "python" },
    { "cespare/vim-toml", ft = "toml" },
    { "peterhoeg/vim-qml", ft = "qml" },  --FIXME https://github.com/neovim/neovim/pull/24812 echo has("patch-9.0.1768")
    { "neoclide/jsonc.vim", ft = "jsonc" },
    { "othree/xml.vim", ft = "xml" },
    { "wsdjeg/vim-autohotkey", ft = "autohotkey" },
    { "plasticboy/vim-markdown", ft = "markdown", dependencies = "godlygeek/tabular" },
}

-- lazy config {{{
require("lazy").setup(plugins, {
    root = g.runtime_dir .. "/plugins",
    checker = { enabled = false },
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

require("util").update_ignore_config()
