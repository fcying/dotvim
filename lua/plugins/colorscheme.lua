return {
    {
        "maxmx03/solarized.nvim",
        lazy = true,
        priority = 1000,
        opts = {
            highlights = function(c)
                return {
                    SpecialKey = { fg = c.red, reverse = false },
                }
            end
        }
    },
    { "sainnhe/everforest", lazy = true, priority = 1000 },
    { "rose-pine/neovim", lazy = true, priority = 1000 },
    { "folke/tokyonight.nvim", lazy = true, priority = 1000 },
}
