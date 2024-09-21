return {
    { "wsdjeg/vim-fetch", lazy = false },
    { "ojroques/nvim-osc52", opts = { silent = true, trim = false } },
    {
        "mbbill/fencview",
        cmd = { "FencView", "FencAutoDetect" },
        init = function()
            vim.g.fencview_autodetect = 0
            vim.g.fencview_checklines = 10
        end,
    },
    {
        "ethanholz/nvim-lastplace",
        lazy = false,
        config = function()
            require("nvim-lastplace").setup {
                lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
                lastplace_open_folds = true
            }
        end
    },
    --{ 'simnalamburt/vim-mundo', event = 'VimEnter' },
}
