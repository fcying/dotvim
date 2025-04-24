return {
    "embear/vim-foldsearch",
    cmd = { "Fw", "Fs", "Fp", "FS", "Ft", "Fl", "Fi", "Fd", "Fe" },
    init = function()
        vim.g.foldsearch_highlight = 1
        vim.g.foldsearch_disable_mappings = 0
    end,
    keys = {
        { "<leader>fp", mode = { "n" }, ':<C-R>=printf("Fp % s", expand("<cword>"))<CR>', desc = "foldsearch" },
        {
            "<leader>fp",
            mode = { "x" },
            function()
                vim.fn.execute("Fp " .. require("util").get_visual_selection())
            end,
            desc = "foldsearch"
        },
    },
}
