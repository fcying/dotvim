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
        -- FIXME: new version change light theme
        commit = "3a19787",
        opts = {
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
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
        opts = {
            variant = "auto", -- auto, main, moon, or dawn
            dark_variant = "main", -- main, moon, or dawn
            dim_inactive_windows = false,
            extend_background_behind_borders = true,

            enable = {
                terminal = true,
                legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                migrations = true, -- Handle deprecated options automatically
            },

            styles = {
                bold = true,
                italic = false,
                transparency = false,
            },
        },
    },
    { "projekt0n/github-nvim-theme", lazy = true }
}
