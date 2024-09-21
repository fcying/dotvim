return {
    "Yggdroot/indentLine",
    cmd = "IndentLinesToggle",
    keys = { { "<leader>i", "<cmd>IndentLinesToggle<CR>", desc = "IndentLinesToggle" } },
    init = function()
        vim.g.indentLine_setColors = 1
        vim.g.indentLine_enabled = 0
        vim.g.indentLine_char_list = { "|", "¦", "┆", "┊" }
    end,
}
