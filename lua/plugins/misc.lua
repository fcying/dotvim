return {
    { "wsdjeg/vim-fetch", lazy = false },
    {
        "mbbill/fencview",
        cmd = { "FencView", "FencAutoDetect" },
        init = function()
            vim.g.fencview_autodetect = 0
            vim.g.fencview_checklines = 10
        end,
    },
    {
        "farmergreg/vim-lastplace",
        init = function ()
            vim.g.lastplace_ignore = "gitcommit,gitrebase,hgcommit,svn,xxd"
            vim.g.lastplace_ignore_buftype = "help,nofile,quickfix"
            vim.g.lastplace_open_folds = 0
        end
    },
    --{ 'simnalamburt/vim-mundo', event = 'VimEnter' },
}
