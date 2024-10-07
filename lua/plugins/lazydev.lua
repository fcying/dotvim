return {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    event = "LspAttach",
    opts = {
        library = {
            vim.g.config_dir .. "/lua",
            "lazy.nvim",
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            -- { path = "wezterm-types", mods = { "wezterm" } }, --justinsgithub/wezterm-types
        },
        enabled = function(root_dir)
            if vim.g.lazydev_enabled ~= nil then
                return vim.g.lazydev_enabled
            end
            local filename = vim.fn.expand("%:t")
            if filename == ".nvim.lua"
                or filename == "init.lua"
                or vim.uv.fs_stat(root_dir .. "/lua") then
                return true
            else
                return false
            end
        end,
    },
}
