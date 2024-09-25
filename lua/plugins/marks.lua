return {
    "chentoast/marks.nvim",
    event = "VimEnter",
    keys = {
        { "<leader>ml", "<cmd>Telescope marks<CR>", desc = "list marks" },
        { "dm<space>", "<cmd>delm!<CR>", desc = "delete mark" },
    },
    config = function()
        require("marks").setup({
            default_mappings = true,
            builtin_marks = {},
            cyclic = true,
            force_write_shada = true,
            refresh_interval = 250,
            sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
            excluded_filetypes = {},
            bookmark_0 = {
                sign = "⚑",
                virt_text = "",
            },
            mappings = {},
        })
    end
}
