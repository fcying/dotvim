local map = require("util").map

return {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        config = function()
            vim.g.flog_default_opts = {
                max_count = 2000,
                merges = 0,
                date = "format:%Y-%m-%d %H:%M",
            }

            local function GFileEdit(mode, history)
                history = history or false
                mode = mode or "edit"
                local result = ""
                local run = ""
                if vim.bo.filetype == "git" then
                    result = fn["fugitive#Cfile"]()
                    --vim.print(result)
                    if #result > 0 then
                        if string.match(result, "+Gdiffsplit") then
                            run = "G" .. mode .. " " .. result
                        elseif string.match(result, "fugitive://") then
                            if history == false then
                                -- edit origin file
                                result = string.gsub(result, "fugitive://", "", 1)
                                result = string.gsub(result, ".git//.-/", "", 1)
                            end
                            run = "G" .. mode .. " " .. result
                        end
                        print(run)
                        if run ~= "" then
                            vim.cmd(run)
                        end
                    end
                end
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("Flog", { clear = true }),
                pattern = { "git", "floggraph" },
                callback = function()
                    vim.g.flog_enable_status = true
                    local opts = { buffer = vim.api.nvim_get_current_buf() }
                    map("n", "e", function() GFileEdit("edit") end, opts)
                    map("n", "ge", function() GFileEdit("edit", true) end, opts)
                    map("n", "<c-t>", function() GFileEdit("tabedit") end, opts)
                    map("n", "<CR>", "<Plug>(FlogVSplitCommitRight) <BAR> :wincmd w<cr>", opts)
                    map("n", "<c-n>", ":wincmd w<cr> <BAR> <Plug>(FlogVNextCommitRight) <BAR> :wincmd w<cr>", opts)
                    map("n", "<c-p>", ":wincmd w<cr> <BAR> <Plug>(FlogVPrevCommitRight) <BAR> :wincmd w<cr>", opts)
                    map("n", "gs", "<Plug>(FlogVSplitStaged) <BAR> :wincmd w<cr>", opts)
                    map("n", "gu", "<Plug>(FlogVSplitUntracked) <BAR> :wincmd w<cr>", opts)
                    map("n", "gU", "<Plug>(FlogVSplitUnstaged) <BAR> :wincmd w<cr>", opts)
                end,
            })
        end
    }
}
