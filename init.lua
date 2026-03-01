vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.is_wsl = vim.fn.isdirectory("/mnt/c") == 1
vim.g.is_win = vim.fn.has("win32") == 1
vim.g.is_tmux = vim.fn.exists("$TMUX") == 1

function _G.join_path(...)
    local sep = vim.g.is_win and "\\" or "/"
    -- 1. Concatenate all arguments using the system separator
    local path = table.concat({ ... }, sep)
    if vim.g.is_win then
        -- Convert all forward slashes to backslashes
        path = path:gsub("/", "\\")
        path = path:gsub("\\\\+", "\\")
    else
        path = path:gsub("//+", "/")
    end
    return path
end

-- set dir path {{{
vim.g.config_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("<sfile>:p")), ":h")
vim.opt.rtp:prepend(vim.g.config_dir)
vim.g.runtime_dir = vim.fs.joinpath(vim.g.config_dir, ".run")

local env_separator = vim.g.is_win and ";" or ":"
vim.env.PATH = vim.fs.joinpath(vim.g.config_dir, "vendor") .. env_separator .. vim.env.PATH

local original_stdpath = vim.fn.stdpath
---@diagnostic disable-next-line: duplicate-set-field
vim.fn.stdpath = function(what)
    local path_map = {
        config = join_path(vim.g.runtime_dir, "config"),
        data   = join_path(vim.g.runtime_dir, "data"),
        state  = join_path(vim.g.runtime_dir, "state"),
        cache  = join_path(vim.g.runtime_dir, "cache"),
        log    = join_path(vim.g.runtime_dir, "log"),
        run    = join_path(vim.g.runtime_dir, "run"),
    }

    if path_map[what] then
        return path_map[what]
    end

    if what == "config_dirs" then
        return { path_map.config }
    elseif what == "data_dirs" then
        return { path_map.data }
    end

    print(what)
    return original_stdpath(what)
end
vim.o.shadafile = vim.fs.joinpath(vim.fn.stdpath("state"), "shadafile")
vim.opt.undodir = vim.fs.joinpath(vim.g.runtime_dir, "undodir_nvim")

local util = require("util")
util.get_root_marker({ ".root", ".git", ".repo", ".svn" })
require("config.project").setup()

-- solarized tokyonight-day everforest rose-pine-dawn
local colorscheme = vim.g.colorscheme or "solarized"
local background = vim.g.background or "light"
vim.opt.background = background

require("config.option")
require("config.keymap")
require("config.lazy")

vim.cmd.colorscheme(colorscheme)
util.update_ignore_config()

if Option.config_post_run then
    Option.config_post_run()
end
