local M = {}
local fn, g, cmd = vim.fn, vim.g, vim.cmd

--custome Option
Option = {
    dir = {},   -- ignore dir
    file = {},  -- ignore file
    mru = {},   -- ignore mru
    rg = {},    -- ignore rg
    lsp = {},   -- ignore lsp server
    cconf = {}, -- for g:gencconf_default_option
}
local option_default = {
    -- ignore list
    dir = { ".root", ".svn", ".git", ".repo", ".ccls-cache", ".cache", ".ccache" },
    file = { "*.sw?", "~$*", "*.bak", "*.exe", "*.o", "*.so", "*.py[co]", "tags" },
    mru = { "*.so", "*.exe", "*.py[co]", "*.sw?", "~$*", "*.bak", "*.tmp", "*.dll" },
    rg = { "--max-columns=300", "--iglob=!obj", "--iglob=!out" },
    cconf = {
        ["*"] = { "-ferror-limit=0" },
        c = { "gcc", "-c", "-std=c11" },
        cpp = { "g++", "-c", "-std=c++14" },
    },
}

M.option = {}
M.find_command = ""
M.root_dir = ""
M.root_marker = ""

-- issue list
-- https://github.com/neovim/neovim/issues/12544 store metatables on vim.b/vim.w/vim.t scopes
-- https://github.com/neovim/neovim/issues/4396 nvim not restore terminal cursorshape settings.lua
-- https://github.com/neovim/neovim/pull/24812 echo has("patch-9.0.1768") lazy.lua
-- https://github.com/neovim/neovim/issues/16843  lua function to get current visual selection

function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    opts.noremap = opts.noremap ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

function M.get_root_marker(root_markers)
    local dir
    for _, item in pairs(root_markers) do
        dir = fn.finddir(item, ".;")
        if fn.empty(dir) == 0 then
            break
        end
    end
    if fn.empty(dir) == 0 then
        M.root_dir = fn.fnamemodify(dir .. "/../", ":p:h")
        M.root_marker = fn.fnamemodify(dir, ":p:h")
    else
        M.root_dir = fn.getcwd()
        M.root_marker = fn.getcwd()
    end
    return M.root_marker, M.root_dir
end

-- FIXME add getregion() function echo has("patch-9.1.0127")
function M.get_visual_selection()
    local _, ls, cs = unpack(vim.fn.getpos("v"))
    local _, le, ce = unpack(vim.fn.getpos("."))
    local result = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1]

    return result
end

function M.config(name, module)
    return function()
        if module == nil then
            require("config")[name]()
        else
            require(module)[name]()
        end
    end
end

function M.update_ignore_config()
    M.option = vim.deepcopy(option_default)

    vim.list_extend(M.option.dir, Option.dir)
    vim.list_extend(M.option.file, Option.file)
    vim.list_extend(M.option.mru, Option.mru)
    vim.list_extend(M.option.rg, Option.rg)

    for _, k in ipairs(M.option.file) do
        table.insert(M.option.rg, "--glob=!" .. k)
    end
    for _, k in ipairs(M.option.dir) do
        table.insert(M.option.rg, "--glob=!" .. k)
    end

    -- gen_clang_conf.vim
    g.gencconf_ignore_dir = M.option.dir
    g.gencconf_ignore_file = M.option.file
    g.gencconf_default_option = vim.tbl_deep_extend("force", M.option.cconf, Option.cconf)
    --vim.notify(vim.inspect(g.gencconf_default_option))

    M.telescope_update_ignore()
end

function M.find_file()
    vim.fn.execute(M.find_command)
end

function M.telescope_update_ignore()
    M.find_command = "Telescope find_files "
    if g.has_rg == 1 then
        M.find_command = M.find_command .. "find_command=rg,--files,--no-ignore,--color=never"
        if M.option.rg ~= {} then
            M.find_command = M.find_command .. "," .. table.concat(M.option.rg, ",")
        end
    end

    if _G["TelescopeGlobalState"] ~= nil then
        local conf = require("telescope.config").values
        conf.vimgrep_arguments = {
            "rg",
            "--no-binary",
            "--color=never",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        }
        for _, v in ipairs(M.option.rg) do
            table.insert(conf.vimgrep_arguments, v)
        end
    end
end

function M.go2def(str, opts)
    opts = opts or {}

    if vim.api.nvim_get_mode() == "v" then
        vim.cmd("<ESC>")
    end

    if vim.o.filetype == "help" then
        pcall(fn.execute, "tag " .. str)
    else
        local bufnr = fn.bufnr()
        local lnum = fn.line(".")

        if opts.mode == "lsp" then
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local client = clients[next(clients)]

            if client ~= nil then
                local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
                ---@diagnostic disable-next-line
                local ret = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 1000)

                --vim.notify(vim.inspect(ret))
                if ret ~= nil and next(ret) then
                    local result = ret[next(ret)].result or {}
                    if #result == 1 then
                        vim.lsp.util.jump_to_location(result[1], client.offset_encoding, false)

                        -- if not jump, fallback ltag
                        if bufnr ~= fn.bufnr() or lnum ~= fn.line(".") then
                            return
                        end
                    elseif #result > 1 then
                        require("telescope.builtin").lsp_definitions()
                        return
                    end
                end
            end
        end

        -- fallback ltag
        local backup = vim.o.tagfunc
        vim.o.tagfunc = ""
        local ret = pcall(fn.execute, "silent ltag " .. str)
        if ret ~= true then
            return
        end

        if fn.getloclist(0, { size = 0 }).size > 1 then
            -- if resut > 1, not auto jump
            if bufnr ~= fn.bufnr() then
                fn.execute("buf " .. bufnr)
            end
            if lnum ~= fn.line(".") then
                vim.cmd("normal " .. lnum .. "G^")
            end

            M.telescope_ltaglist()
        end
        vim.o.tagfunc = backup
    end
end

function M.telescope_ltaglist(opts)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local entry_display = require("telescope.pickers.entry_display")
    local previewers = require("telescope.previewers")
    local action_set = require("telescope.actions.set")
    local action_state = require("telescope.actions.state")

    opts = opts or {}

    local displayer = entry_display.create({
        separator = " | ",
        items = {
            { remaining = true },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        --vim.notify(vim.inspect(entry))
        return displayer({
            { entry.filename },
            { entry.text },
        })
    end

    local entry_maker = function(entry)
        local filename = vim.fn.bufname(entry.bufnr)
        local scode = entry.pattern
        scode = string.gsub(scode, [[^%^\V]], "")
        scode = string.gsub(scode, [[\%$]], "")
        return {
            value = entry,
            filename = filename,
            text = string.gsub(scode, [[^%s*]], ""),
            scode = scode,
            lnum = 1,
            col = 1,
            tag = entry.text,
            ordinal = filename .. ": " .. entry.text,
            display = make_display,
        }
    end

    local locations = vim.fn.getloclist(0)
    pickers.new(opts, {
        prompt_title = "Ltaglist",
        initial_mode = "normal",
        sorter = conf.generic_sorter(opts),
        previewer = previewers.ctags.new(opts),
        finder = finders.new_table({
            results = locations,
            entry_maker = entry_maker,
        }),
        attach_mappings = function()
            action_set.select:enhance({
                post = function()
                    local selection = action_state.get_selected_entry()

                    if selection.scode then
                        local scode = selection.scode
                        scode = string.gsub(scode, "[$]$", "")
                        scode = string.gsub(scode, [[\\]], [[\]])
                        scode = string.gsub(scode, [[\/]], [[/]])
                        scode = string.gsub(scode, "[*]", [[\*]])

                        vim.fn.search(scode, "w")
                        vim.cmd("norm! zz")
                    else
                        vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
                    end
                end,
            })
            return true
        end,
    }):find()
end

-- tags ltag {{{
vim.cmd([[ set tags=tags,tags; ]])
function M.removetags()
    cmd("ClearClangConf")
    cmd("ClearCtags")
end

function M.gentags(type)
    type = type or 0
    cmd("ClearClangConf")
    cmd("GenClangConf")
    if vim.fn.exists(":LspRestart") ~= 0 then
        cmd("LspRestart")
    end
    if type == 0 then
        cmd("GenCtags")
    end
end

M.map("n", "ta", "<cmd>lua require('util').gentags()<CR>")
M.map("n", "tc", "<cmd>lua require('util').gentags(1)<CR>")
M.map("n", "tr", "<cmd>lua require('util').removetags()<CR>")

return M
