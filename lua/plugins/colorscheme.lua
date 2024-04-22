return {
    --{
    --    "skywind3000/vim-color-patch",
    --    lazy = false,
    --    init = function()
    --        vim.g.cpatch_path = vim.g.config_dir .. vim.g.dir_separator .. "colors_patch"
    --    end
    --},
    {
        "maxmx03/solarized.nvim",
        lazy = true,
        opts = {
            --theme = "neo",
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
    { "sainnhe/everforest", lazy = true },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "folke/tokyonight.nvim", lazy = true },
}
