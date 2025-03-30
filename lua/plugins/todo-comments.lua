return {
    "folke/todo-comments.nvim",
    pattern = "VeryLazy",
    config = function()
        require("todo-comments").setup {
            signs = false,
        }
    end,
}
