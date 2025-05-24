return {
    "al1-ce/just.nvim",
    cmd = { "JustSelect" },
    keys = { { "<leader>rs", "<cmd>JustSelect<CR>", desc = "JustSelect" } },
    dependencies = {
        "nvim-lua/plenary.nvim",         -- async jobs
        "nvim-telescope/telescope.nvim", -- task picker (optional)
        "j-hui/fidget.nvim",             -- task progress (optional)
        "al1-ce/jsfunc.nvim",            -- extension library
    },
    config = function()
        require("just").setup({
            play_sound = false,
            open_qf_on_error = true,
            open_qf_on_run = true,
            open_qf_on_any = true,
        })
    end
}
