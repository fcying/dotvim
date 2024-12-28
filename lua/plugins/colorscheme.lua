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
        ---@type solarized.config
        opts = {
            palette = "solarized", -- solarized (default) | selenized
            ---@diagnostic disable-next-line: unused-local
            on_colors = function(colors, color)
                return {
                }
            end,
            on_highlights = function(c, _)
                ---@type solarized.highlights
                return {
                    Empty = {},
                    ["@lsp.type.enumMember"] = { link = "Constant" },
                    ["@lsp.type.macro"] = { link = "Macro" },
                    ["@lsp.type.parameter"] = { fg = c.base0, italic = true },
                    ["@lsp.type.namespace"] = { link = "Empty" },
                    ["@keyword.directive"] = { link = "PreProc" },
                    ["@keyword.directive.define"] = { link = "Define" },
                    Keyword = { fg = c.green },
                    Identifier = { fg = c.base00 },
                    Constant = { fg = c.violet },
                    Comment = { italic = true },
                    Number = { fg = c.magenta },
                    Visual = { bg = c.mix_base01, standout = false, fg = "NONE" },
                    Search = { fg = c.yellow, reverse = true },
                    DashboardHeader = { fg = c.base0 },
                    TelescopeSelection = { bg = c.mix_base01 },
                }
            end,
        },
        config = function(_, opts)
            vim.o.termguicolors = true
            require("solarized").setup(opts)
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
        opts = {
            variant = "auto",      -- auto, main, moon, or dawn
            dark_variant = "main", -- main, moon, or dawn
            dim_inactive_windows = false,
            extend_background_behind_borders = true,

            enable = {
                terminal = true,
                legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                migrations = true,        -- Handle deprecated options automatically
            },

            styles = {
                bold = true,
                italic = false,
                transparency = false,
            },
        },
    },
    { "projekt0n/github-nvim-theme", lazy = true },
    { "sainnhe/everforest", lazy = true },
}
