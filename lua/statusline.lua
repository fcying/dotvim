local M = {}

function M.fileencoding()
    local buf_opt = vim.bo[vim.api.nvim_get_current_buf()]
    local ret = buf_opt.fileencoding
    if buf_opt.bomb then
        ret = string.format("%s-bom", ret)
    end
    return ret
end

function M.git_status()
    local status = vim.fn.FugitiveHead(7)
    if vim.b.flog_status_summary then
        if string.match(vim.b.flog_status_summary, "%d+") then
            status = status .. "*"
        end
    end
    return status, false
end

function M.indent()
    local ret = ""

    if vim.bo.buftype == "terminal" then
        return ret
    end

    if vim.bo.expandtab then
        ret = "sw=" .. vim.bo.shiftwidth
    else
        ret = "ts=" .. vim.bo.tabstop
    end

    if vim.bo.textwidth ~= 80 and vim.bo.textwidth < 9999 then
        -- If textwidth is very high, we are in 'soft' wrapping mode, don't
        -- display textwidth.
        ret = ret .. " tw=" .. vim.bo.textwidth
    end

    return ret
end

function M.lsp_progress()
    local messages = vim.lsp.util.get_progress_messages()

    if vim.tbl_count(messages) > 0 then
        local message1 = messages[1]
        --vim.print(messages)

        local name = message1.name or nil
        local title = message1.title or nil
        local msg = message1.message or nil
        local percentage = message1.percentage or nil
        local progress = message1.progress or true

        if progress then
            return (name or "")
                .. (title and (" " .. title) or "")
                .. (msg and (" " .. msg) or "")
                .. (percentage and (" " .. percentage .. "%%") or "")
        end
    end

    return ""
end

function M.search()
    if vim.v.hlsearch == 1 then
        local ok, searchcount = pcall(vim.fn.searchcount)

        if ok and searchcount["total"] > 0 then
            return "["
                .. searchcount["current"]
                .. "/"
                .. searchcount["total"]
                .. "]"
        end
    end
    return ""
end

function M.macro_recording()
    local reg = vim.fn.reg_recording()

    if reg ~= "" then
        return "recording @" .. reg
    end

    return ""
end

return M
