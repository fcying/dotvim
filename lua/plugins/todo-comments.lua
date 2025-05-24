return {
    "folke/todo-comments.nvim",
    pattern = "VeryLazy",
    config = function()
        require("todo-comments").setup {
            signs = false,
            search = {
                command = "rg",
                args = {
                    "--no-binary",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
            },
        }
    end,
}
