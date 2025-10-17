return {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    keys = {
        { "<leader>mv", "<cmd>Markview<CR>", desc = "Markview" },
    },
    opts = {
        experimental = {
            check_rtp = false,
        },
        preview = {
            enable = false,
            hybrid_modes = {},
        },
    },
}
