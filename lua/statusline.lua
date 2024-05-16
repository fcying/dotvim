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
    --local msg = vim.lsp.util.get_progress_messages()
    local msg = {}
    for _, client in ipairs(vim.lsp.get_clients()) do
        for progress in client.progress do
            local value = progress.value
            if type(value) == "table" and value.kind then
                msg.name = client.name
                msg.message = value.message
                msg.title = value.title
                msg.kind = value.kind
                if value.kind == "end" then
                    msg.percentage = 100
                else
                    msg.percentage = value.percentage
                end
            end
        end
    end

    if vim.tbl_count(msg) > 0 then
        --vim.print(msg)

        return (msg.name or "")
            .. (msg.title and (" " .. msg.title) or "")
            .. (msg.message and (" " .. msg.message) or "")
            .. (msg.percentage and (" " .. msg.percentage .. "%%") or "")
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
