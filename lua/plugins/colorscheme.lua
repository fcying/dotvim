return {
    {
        "maxmx03/solarized.nvim",
        lazy = true,
        priority = 1000,
        opts = {
            --theme = 'neo',
            highlights = function(c)
                return {
                    SpecialKey = { fg = c.red, reverse = false },
                    Keyword = { fg = c.green },
                    Identifier = { fg = c.base0 },
                    Constant = { fg = c.violet },
                }
            end
        }
    },
    { "sainnhe/everforest", lazy = true, priority = 1000 },
    { "rose-pine/neovim", name = "rose-pine", lazy = true, priority = 1000 },
    { "folke/tokyonight.nvim", lazy = true, priority = 1000 },
}
