local M = {}

local dashboard_opts = {
    enabled = false,
    preset = {
        header = require("ascii_logo").neovim2,
        ---@type snacks.dashboard.Item[]
        keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
                icon = " ",
                key = "f",
                desc = "Find File",
                action = require("util").findFile,
            },
            {
                icon = " ",
                key = "/",
                desc = "Find Text",
                action = require("util").grep,
            },
            { icon = " ", key = "m", desc = "Recent Files", action = function() Snacks.picker.recent() end },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
    }
}

local snacks_outline = function(opts)
    opts = opts or { buf = "cur" }
    require("ctags-outline").snacks_ctags_outline(opts)
end

M.findFile = function()
    local option = require("util").option
    local opts = {
        finder = "files",
        format = "file",
        show_empty = true,
        follow = false,
        supports_live = true,
        hidden = true,
        ignored = false,
        exclude = {},
        cmd = "rg",
        args = {
            "--no-config",
            "--no-binary",
        }
    }
    for _, v in ipairs(option.dir) do
        table.insert(opts.exclude, v)
    end
    for _, v in ipairs(option.file) do
        table.insert(opts.exclude, v)
    end
    Snacks.picker.files(opts)
end

M.grep = function()
    local option = require("util").option
    local opts = {
        finder = "grep",
        regex = true,
        format = "file",
        show_empty = true,
        live = true,
        supports_live = true,
        hidden = true,
        ignored = false,
        exclude = {},
        cmd = "rg",
        args = {
            "--no-config",
            "--no-binary",
        }
    }
    for _, v in ipairs(option.dir) do
        table.insert(opts.exclude, v)
    end
    for _, v in ipairs(option.file) do
        table.insert(opts.exclude, v)
    end
    local mode = vim.api.nvim_get_mode().mode
    if mode == "n" then
        Snacks.picker.grep(opts)
    elseif mode == "v" then
        Snacks.picker.grep_word(opts)
    end
end

M.ltaglist = function()
    local items = {}
    local locations = vim.fn.getloclist(0)
    for i, item in ipairs(locations) do
        local filename = vim.fn.bufname(item.bufnr)
        local scode = item.pattern
        scode = string.gsub(scode, [[^%^\V]], "")
        scode = string.gsub(scode, [[\%$]], "")
        table.insert(items, {
            idx = i,
            score = i,
            -- text = string.gsub(scode, [[^%s*]], ""),
            text = filename,
            file = filename,
            scode = scode,
            bufnr = item.bufnr,
            lnum = item.lnum,
            col = item.col,
        })
    end
    return Snacks.picker({
        title = "ltaglist",
        items = items,
        format = function(item)
            local ret = {}
            ret[#ret + 1] = { ("%s"):format(item.file), "SnacksPickerCmd" }
            ret[#ret + 1] = { ("\t%s"):format(item.scode), "SnacksPickerLabel" }
            return ret
        end,
        confirm = function(picker, item)
            picker:close()
            local scode = item.scode
            vim.api.nvim_set_current_buf(item.bufnr)
            scode = string.gsub(scode, "[$]$", "")
            scode = string.gsub(scode, [[\\]], [[\]])
            scode = string.gsub(scode, [[\/]], [[/]])
            scode = string.gsub(scode, "[*]", [[\*]])
            vim.fn.search(scode, "w")
            vim.cmd("norm! zz")
        end,
    })
end

M.setup = { --{{{
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "fcying/telescope-ctags-outline.nvim" },
    },
    keys = { -- {{{
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "<leader>q", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
        -- find
        { "fe", function() Snacks.explorer() end, desc = "file explorer" },
        { "ff", require("util").findFile, desc = "Find Files" },
        { "fg", require("util").grep, mode = { "n", "x" }, desc = "Grep" },
        { "fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "fr", function() Snacks.picker.recent() end, desc = "Recent" },
        { "fh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "fl", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "fm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "fn", function() Snacks.notifier.show_history({}) end, desc = "Notify" },
        { "fc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        { "fR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "fT", function() Snacks.picker.todo_comments() end, desc = "Todo" },
        { "go", function() snacks_outline() end, desc = "outline" },
        { "gO", function() snacks_outline({ buf = "all" }) end, desc = "outline all" },
    },
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
        bigfile = {
            notify = true,
            size = 1.5 * 1024 * 1024,
            ---@param ctx {buf: number, ft:string}
            setup = function(ctx)
                vim.b.minianimate_disable = true
                vim.schedule(function()
                    vim.bo[ctx.buf].syntax = ctx.ft
                end)
            end,
        },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        quickfile = {
            enabled = true,
            exclude = { "latex" },
        },
        statuscolumn = { enabled = true },
        words = { enabled = false },
        styles = {
            notification = {
                wo = { wrap = true } -- Wrap notifications
            }
        },
        input = {},
        explorer = {},
        picker = { -- {{{
            layout = {
                cycle = true,
                preset = "dropdown",
                layout = {
                    width = 0.8,
                },
            },
            win = {
                input = {
                    keys = {
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                        ["<C-c>"] = { "cancel" },
                    },
                },
            },
            sources = {
                explorer = {
                    diagnostics = false,
                    layout = {
                        layout = {
                            width = 30
                        }
                    }
                }
            }
        },
        dashboard_opts,
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                    "<leader>ub")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>i")

                local outline = require("ctags-outline")
                outline.setup(Option.ctags_outline)
            end,
        })
    end,
}

return M
