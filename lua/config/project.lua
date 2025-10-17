local M = {}
local fn, g = vim.fn, vim.g
local util = require("util")
local config_name = { ".nvim.lua", ".pvimrc" }
local config_path = nil

local function set_config()
    if config_path then
        vim.cmd.source(vim.fn.fnameescape(config_path))
    end
end

local function find_config()
    for _, name in ipairs(config_name) do
        config_path = vim.fs.find({ name }, { type = "file", path = util.root_marker, upward = true })[1]
        if config_path then
            break
        end
    end

    --vim.notify(config_path)
    if not config_path then
        config_path = util.root_marker .. "/" .. config_name[1]
        return false
    end

    return true
end

function M.edit_config()
    if not config_path then
        find_config()
    end
    if config_path and fn.filereadable(config_path) == 1 then
        vim.cmd.edit(config_path)
    end
end

function M.load_config()
    if find_config() then
        set_config()
    end
end

function M.load_user_config()
    g.file_vimrc_local = vim.loop.os_homedir() .. "/.vimrc.local"
    if fn.filereadable(g.file_vimrc_local) == 1 then
        vim.cmd.source(g.file_vimrc_local)
    end
end

local init_done = false
function M.setup()
    if init_done then
        return
    end
    init_done = true

    M.load_user_config()
    M.load_config()

    vim.api.nvim_create_augroup("project_config", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = "project_config",
        pattern = config_name,
        callback = function()
            M.load_config()
        end,
        nested = true,
    })
    vim.api.nvim_create_autocmd("SourcePost", {
        group = "project_config",
        pattern = config_name,
        callback = function()
            util.update_ignore_config()
        end,
    })
end

return M
