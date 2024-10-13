return {
    "lambdalisue/suda.vim",
    -- lazy = false,
    cmd = { "SudaRead", "SudaWrite" },
    keys = {
        { "<leader>sr", "<cmd>SudaRead<CR>", desc = "Read Sudo Files" },
        { "<leader>sw", "<cmd>SudaWrite<CR>", desc = "Write Sudo Files" }
    },
    init = function()
        --FIXME: https://github.com/lambdalisue/suda.vim/issues/54
        vim.g.suda_smart_edit = 0
    end
}
