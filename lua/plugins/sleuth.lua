-- auto adjust 'shiftwidth' and 'expandtab'
return {
    "tpope/vim-sleuth",
    init = function()
        --vim.g.sleuth_make_heuristics = 0
        vim.g.sleuth_heuristics = 0
        vim.g.sleuth_vue_heuristics = 1
    end,
}
