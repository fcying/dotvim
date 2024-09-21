return {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle" },
    keys = {
        { "<leader>or", "<cmd>OverseerRun<CR>", desc = "OverseerRun" },
        { "<leader>ot", "<cmd>OverseerToggle<CR>", desc = "OverseerToggle" },
        { "<leader>bb", "<cmd>lua Option.build()<CR>", desc = "Overseer build" },
        { "<leader>br", "<cmd>lua Option.release()<CR>", desc = "Overseer release" },
    },
    config = function()
        require("overseer").setup({
            -- strategy = {
            --     "terminal",
            --     -- "toggleterm",
            --     use_shell = true,
            --     quit_on_exit = "never", -- never success always
            -- }
        })
    end
}
