return {
    "folke/todo-comments.nvim",
    -- cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    cmd = { "TodoTelescope" },
    config = function()
        require("todo-comments").setup {
            signs = false,
        }
    end,
}
