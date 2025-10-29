-- return {
--     "OXY2DEV/markview.nvim",
--     ft = "markdown",
--     dependencies = {
--         "nvim-treesitter/nvim-treesitter",
--         "nvim-tree/nvim-web-devicons"
--     },
--     keys = {
--         { "<leader>mt", "<cmd>Markview<CR>", desc = "Markdown toggle" },
--     },
--     opts = {
--         experimental = {
--             check_rtp = false,
--         },
--         preview = {
--             enable = false,
--             hybrid_modes = {},
--         },
--     },
-- }


return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    ft = "markdown",
    keys = {
        { "<leader>mt", "<cmd>RenderMarkdown toggle<CR>", desc = "Markdown toggle" },
        { "<leader>mp", "<cmd>RenderMarkdown preview<CR>", desc = "Markdown preview" },
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
    },
}
