local g = vim.g
local map = require("util").map

g.plug_dir = g.config_dir .. "/.plugged"
local lazypath = g.plug_dir .. "/lazy.nvim"
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

require("lazy").setup({
    { "fcying/gen_clang_conf.vim", lazy = false },
    { "wsdjeg/vim-fetch", lazy = false },
    { "lambdalisue/suda.vim", cmd = { "SudaRead", "SudaWrite" } },
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

    -- editor
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
    { "t9md/vim-choosewin", event = "VimEnter" },
    { "Yggdroot/indentLine", cmd = "IndentLinesToggle" },
    { "chentoast/marks.nvim", event = "VimEnter", config = config("marks") },
    { "mg979/vim-visual-multi", event = "VimEnter" },
    { "easymotion/vim-easymotion", event = "VimEnter" },
    { "terryma/vim-expand-region", event = "VimEnter", config = config("vim_expand_region") },
    { "andymass/vim-matchup", event = "VimEnter" },
    {
        "fcying/vim-foldsearch",
        cmd = { "Fp", "Fw", "Fs", "FS", "Fl", "Fi", "Fd", "Fe" },
    },
    { "preservim/tagbar", cmd = "TagbarToggle" },
    { import = "plugins.telescope" },
    { import = "plugins.fern" },

    -- tool
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
        "neovim/nvim-lspconfig",
        config = config("setup", "lsp"),
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim" },
            { "williamboman/mason.nvim", lazy = false, config = config("mason", "lsp") },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = config("null_ls", "lsp"),
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
                build = g.make .. " install_jsregexp",
                config = config("luasnip"),
                dependencies = { "rafamadriz/friendly-snippets" }
            },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-omni" },
            { "quangnguyen30192/cmp-nvim-tags" },
            { "uga-rosa/cmp-dictionary" },
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
    { "peterhoeg/vim-qml", ft = "qml" },
    { "neoclide/jsonc.vim", ft = "jsonc" },
    { "othree/xml.vim", ft = "xml" },
    { "wsdjeg/vim-autohotkey", ft = "autohotkey" },
    { "plasticboy/vim-markdown", ft = "markdown", dependencies = "godlygeek/tabular" },
}, {
    -- lazy config {{{
    root = g.plug_dir,
    lockfile = g.plug_dir .. "/lazy-lock.json",
    state = g.plug_dir .. "/state.json",
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
            ---@type string[]
            paths = { g.config_dir, g.config_dir .. "../" },
            ---@type string[] list any plugins you want to disable here
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
        -- install missing plugins on startup.
        missing = true,
        colorscheme = { "desert" },
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
    readme = {
        root = g.plug_dir .. "/readme",
        files = { "README.md", "lua/**/README.md" },
        skip_if_doc_exists = true,
    },
})

require("util").update_ignore_config()
