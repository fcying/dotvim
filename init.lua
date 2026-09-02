vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.is_wsl = vim.fn.isdirectory("/mnt/c") == 1 and not (vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT)
vim.g.is_win = vim.fn.has("win32") == 1

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

if vim.fn.has("nvim-0.12") == 0 then
    vim.notify("This config requires Neovim 0.12 or newer", vim.log.levels.ERROR)
end

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

-- Query the host terminal instead of guessing its palette from the platform.
local host_terminal_colors = { palette = {} }
local terminal_group = vim.api.nvim_create_augroup("terminal_colors", { clear = true })

local function rgb_to_hex(red, green, blue)
    if #red > 4 or #green > 4 or #blue > 4 then
        return nil
    end

    local function to_byte(component)
        local maximum = 16 ^ #component - 1
        return math.floor(tonumber(component, 16) * 255 / maximum + 0.5)
    end
    return string.format("#%02X%02X%02X", to_byte(red), to_byte(green), to_byte(blue))
end

local function has_complete_palette()
    for index = 0, 15 do
        if not host_terminal_colors.palette[index] then
            return false
        end
    end
    return true
end

local function apply_terminal_colors()
    if has_complete_palette() then
        for index, color in pairs(host_terminal_colors.palette) do
            vim.g["terminal_color_" .. index] = color
        end
    end

    if host_terminal_colors.foreground and host_terminal_colors.background then
        local colors = { fg = host_terminal_colors.foreground, bg = host_terminal_colors.background }
        vim.api.nvim_set_hl(0, "TerminalNormal", colors)
        vim.api.nvim_set_hl(0, "TerminalFloatBorder", colors)
    else
        vim.api.nvim_set_hl(0, "TerminalNormal", { link = "Normal" })
        vim.api.nvim_set_hl(0, "TerminalFloatBorder", { link = "FloatBorder" })
    end
    vim.api.nvim_set_hl(0, "TerminalVisual", { link = "Visual" })
end

local function query_host_terminal_colors()
    if #vim.api.nvim_list_uis() == 0 then
        return
    end

    local queries = { "\027]10;?\027\\", "\027]11;?\027\\" }
    for index = 0, 15 do
        queries[#queries + 1] = string.format("\027]4;%d;?\027\\", index)
    end
    vim.api.nvim_ui_send(table.concat(queries))
end

vim.api.nvim_create_autocmd("TermResponse", {
    group = terminal_group,
    callback = function(event)
        local sequence = event.data.sequence
        local index, red, green, blue = sequence:match("^\027%]4;(%d+);rgb:(%x+)/(%x+)/(%x+)$")
        if index then
            local color = rgb_to_hex(red, green, blue)
            index = tonumber(index)
            if color and index and index <= 15 then
                host_terminal_colors.palette[index] = color
                apply_terminal_colors()
            end
            return
        end

        local kind, alpha
        kind, red, green, blue = sequence:match("^\027%](1[01]);rgb:(%x+)/(%x+)/(%x+)$")
        if not kind then
            kind, red, green, blue, alpha = sequence:match("^\027%](1[01]);rgba:(%x+)/(%x+)/(%x+)/(%x+)$")
            if alpha and #alpha > 4 then
                return
            end
        end

        local color = kind and rgb_to_hex(red, green, blue)
        if color then
            host_terminal_colors[kind == "10" and "foreground" or "background"] = color
            apply_terminal_colors()
        end
    end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
    group = terminal_group,
    callback = apply_terminal_colors,
})
vim.api.nvim_create_autocmd("UIEnter", {
    group = terminal_group,
    callback = query_host_terminal_colors,
})
vim.api.nvim_create_autocmd("TermOpen", {
    group = terminal_group,
    callback = function()
        local highlights = vim.opt_local.winhighlight:get()
        highlights.Normal = "TerminalNormal"
        highlights.NormalNC = "TerminalNormal"
        highlights.NormalFloat = "TerminalNormal"
        highlights.FloatBorder = "TerminalFloatBorder"
        highlights.Visual = "TerminalVisual"
        vim.opt_local.winhighlight = highlights
    end,
})

vim.cmd.colorscheme(colorscheme)
vim.schedule(query_host_terminal_colors)
util.update_ignore_config()

if Option.config_post_run then
    Option.config_post_run()
end
