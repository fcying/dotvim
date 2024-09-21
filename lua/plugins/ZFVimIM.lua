return {
    "ZSaberLv0/ZFVimIM",
    event = "InsertEnter",
    dependencies = { "ZSaberLv0/ZFVimJob", "fcying/ZFVimIM_wubi_jidian" },
    init = function()
        vim.g.ZFVimIM_cachePath = vim.g.runtime_dir .. vim.g.dir_separator .. "ZFVimIM"
        vim.g.ZFVimIM_cloudAsync_outputTo = {
            outputType = "statusline",
            outputId = "ZFVimIM_cloud_async",
        }
        vim.g.ZFJobVerboseLogEnable = 0

        local db_file = "vim_wubi.txt"
        local repo_path
        if vim.g.is_win == 1 then
            repo_path = "d:/sync/tool/rime"
        else
            repo_path = vim.fn.expand("~/sync/tool/rime")
        end
        if vim.loop.fs_stat(repo_path .. "/" .. db_file) then
            local function db_init()
                local db = vim.fn.ZFVimIM_dbInit({ name = "custom", editable = 0, priority = 200 })
                vim.fn.ZFVimIM_cloudRegister({
                    mode = "local",
                    dbId = db["dbId"],
                    repoPath = repo_path,
                    dbFile = db_file,
                })
            end
            vim.api.nvim_create_autocmd("User", {
                group = vim.api.nvim_create_augroup("ZFVimIM_custom_augroup", { clear = true }),
                pattern = { "ZFVimIM_event_OnDbInit" },
                callback = function() db_init() end
            })
        end
    end
}
