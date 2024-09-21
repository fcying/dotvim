-- FIXME add wrap or fix wrapped-compact format
return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            timeout = 3000,
            max_width = 200,
            icons = {
                ERROR = "[E]",
                WARN  = "[W]",
                INFO  = "[I]",
                DEBUG = "[D]",
                TRACE = "[T]",
            },
        })
        --vim.cmd([[
        --    highlight NotifyINFOIcon guifg=#009f9f
        --    highlight NotifyINFOTitle guifg=#009f9f
        --]])

        if NoiceEn == nil then
            --FIXME https://github.com/rcarriga/nvim-notify/issues/205
            -- vim.notify = require("notify")
            vim.notify = vim.schedule_wrap(require("notify")) ---@diagnostic disable-line
            _G.print = function(...)
                local print_safe_args = {}
                local _ = { ... }
                for i = 1, #_ do
                    table.insert(print_safe_args, tostring(_[i]))
                end
                local msg = table.concat(print_safe_args, " ")
                vim.notify(msg, vim.log.levels.INFO)
            end
            --- @diagnostic disable-next-line
            vim.print = function(...)
                for i = 1, select("#", ...) do
                    local o = select(i, ...)
                    if type(o) == "string" then
                        vim.notify(o, vim.log.levels.INFO)
                    else
                        vim.notify(vim.inspect(o), vim.log.levels.INFO)
                    end
                end
            end
            -- redir pcall message, get treesitter error
            --_G.error = function(...)
            --    local print_safe_args = {}
            --    local _ = { ... }
            --    for i = 1, #_ do
            --        table.insert(print_safe_args, tostring(_[i]))
            --    end
            --    local msg = table.concat(print_safe_args, " ")
            --    if string.match(msg, "^no parser for.*treesitter%-parsers$") then
            --        return
            --    end
            --    vim.notify(msg, vim.log.levels.ERROR)
            --end
        end
    end
}
