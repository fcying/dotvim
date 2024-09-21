return {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "Bilal2453/luvit-meta" }, -- optional `vim.uv` typings
    event = "LspAttach",
    opts = {
        library = {
            vim.g.config_dir .. "/lua",
            { path = "luvit-meta/library", words = { "vim%.uv", "vim%.loop" } },
            { path = "lazy.nvim", words = { "LazyPluginSpec" } },
        },
        enabled = function(_)
            local util = require("util")
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
}
