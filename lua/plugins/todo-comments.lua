return {
    "folke/todo-comments.nvim",
    -- event = "VeryLazy",
    -- cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    cmd = { "TodoTelescope" },
    config = function()
        require("todo-comments").setup {
            signs = false,
        }
    end,
}
