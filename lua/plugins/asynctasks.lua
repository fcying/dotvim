local asyncrun_config = function()
    vim.g.asyncrun_bell = 1
    vim.g.asyncrun_silent = 0
    vim.g.asyncrun_open = 8
    vim.g.asyncrun_rootmarks = { ".root", ".git", ".svn" }
    vim.api.nvim_create_augroup("asyncrun", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        group = "asyncrun",
        pattern = { "AsyncRunStop" },
        callback = function()
            if vim.g.asyncrun_code == 0 then
                vim.notify("AsyncRun Success", "info") ---@diagnostic disable-line
                if Option.asyncrun_auto_close_qf then
                    vim.cmd("cclose")
                end
                if Option.asyncrun_post_run then
                    Option.asyncrun_post_run()
                end
            else
                vim.notify("AsyncRun Failed!", "error") ---@diagnostic disable-line
            end
        end,
    })
end

local asynctasks_config = function()
    vim.g.asynctasks_config_name  = { ".tasks", ".root/.tasks", ".git/.tasks" }
    vim.g.asynctasks_extra_config = { vim.g.config_dir .. "/etc/asynctasks.tasks" }
    vim.g.asynctasks_template     = vim.g.config_dir .. "/etc/asynctasks_template.tasks"
    vim.g.asynctasks_term_pos     = "toggleterm2"
    vim.g.asynctasks_term_reuse   = 1
    vim.g.asynctasks_term_focus   = 0
    vim.g.asynctasks_term_close   = 0
end

return {
    {
        "skywind3000/asyncrun.vim",
        -- "fcying/asyncrun.vim",
        version = "*",
        cmd = { "AsyncRun", "AsyncStop" },
        init = asyncrun_config,
        config = function()
            require("asyncrun.toggleterm2").setup({
                mapping = "<leader>tt",
                start_in_insert = false,
                clear_env = false,
                go_back = true,
            })
        end
    },
    {
        "skywind3000/asynctasks.vim",
        cmd = { "AsyncTask", "AsyncTaskMacro", "AsyncTaskList", "AsyncTaskEdit", },
        keys = {
            { "<leader>ra", "<cmd>AsyncTask all<CR>", desc = "AsyncTask build all" },
            { "<leader>rf", "<cmd>AsyncTask factory<CR>", desc = "AsyncTask build factory" },
            { "<leader>rb", "<cmd>AsyncTask build<CR>", desc = "AsyncTask build debug" },
            { "<leader>rr", "<cmd>AsyncTask release<CR>", desc = "AsyncTask build release" },
            { "<leader>rl", "<cmd>AsyncTask lib<CR>", desc = "AsyncTask build lib" },
            { "<leader>rt", "<cmd>AsyncTask test<CR>", desc = "AsyncTask build test" },
            { "<leader>rc", "<cmd>AsyncTask clean<CR>", desc = "AsyncTask build clean" },
        },
        init = asynctasks_config,
    }
}
