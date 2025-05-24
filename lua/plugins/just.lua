return {
    "al1-ce/just.nvim",
    cmd = { "JustSelect" },
    dependencies = {
        "nvim-lua/plenary.nvim",         -- async jobs
        "nvim-telescope/telescope.nvim", -- task picker (optional)
        "j-hui/fidget.nvim",             -- task progress (optional)
        "al1-ce/jsfunc.nvim",            -- extension library
    },
    config = true
}
