return {
    "folke/todo-comments.nvim",
    -- event = "VeryLazy",
    cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    config = function()
        require("todo-comments").setup {
            signs = false,
        }
    end,
}
