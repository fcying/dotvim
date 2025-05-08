return {
    "kevinhwang91/nvim-ufo",
    event = { "BufNewFile", "BufRead" },
    dependencies = "kevinhwang91/promise-async",
    config = function()
        vim.keymap.set("n", "zn", require("ufo").openAllFolds)
        vim.keymap.set("n", "zm", require("ufo").closeAllFolds)

        require("ufo").setup {
            close_fold_kinds_for_ft = {
                default = { "imports", "comment" },
                c = { "comment", "region" },
            },
        }
    end,
}
