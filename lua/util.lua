local M = {}
local fn, g, cmd = vim.fn, vim.g, vim.cmd

--custome Option
Option = {
    dir = {},                     -- ignore dir
    file = {},                    -- ignore file
    mru = {},                     -- ignore mru
    rg = {},                      -- ignore rg
    lsp = {},                     -- ignore lsp server
    gencconf_default_option = {}, -- for g:gencconf_default_option
    asyncrun_auto_close_qf = false,
    asyncrun_post_run = nil,
    just_post_run = nil,
    config_post_run = nil,
    clangd_query_driver = nil,
    compile_commands_dir = nil,
    ctags_outline = {
        ctags = { "ctags", "--options=" .. g.config_dir .. "/etc/ctags" },
        ft_opt = {
            c = "--c-kinds=fk",
            cpp = "--c++-kinds=fk --language-force=C++",
            vim = "--vim-kinds=fk",
            sh = "--sh-kinds=fk",
            zsh = "--sh-kinds=fk",
            lua = "--lua-kinds=fk",
            go = "--go-kinds=fk",
        },
        --sorting_strategy = "ascending",
    }
}
local option_default = {
    -- ignore list
    dir = { ".root", ".svn", ".git", ".repo", ".ccls-cache", ".cache", ".ccache", ".run", "CMakeFiles" },
    file = { "*.sw?", "~$*", "*.bak", "*.exe", "*.o", "*.so", "*.py[co]", "tags" },
    mru = { "*.so", "*.exe", "*.py[co]", "*.sw?", "~$*", "*.bak", "*.tmp", "*.dll" },
    rg = { "--max-columns=300", "--iglob=!obj", "--iglob=!out" },
    gencconf_default_option = {
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
-- https://github.com/neovim/neovim/issues/16843  lua function to get current visual selection
-- https://github.com/neovim/neovim/issues/12544 store metatables on vim.b/vim.w/vim.t scopes
-- https://github.com/neovim/neovim/issues/4396 nvim not restore terminal cursorshape settings.lua
-- https://github.com/neovim/neovim/issues/22478  Press ENTER message

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
            M.root_dir = fn.fnamemodify(dir .. "/../", ":p:h")
            M.root_marker = fn.fnamemodify(dir, ":p:h")
            return M.root_marker, M.root_dir
        end
    end
    M.root_dir = fn.getcwd()
    M.root_marker = fn.getcwd()
    return M.root_marker, M.root_dir
end

function M.get_last_directory(path)
    path = path:gsub("[/\\]$", "")
    local last_dir = path:match("[\\/]([^\\/]+)$")
    return last_dir
end

-- FIXME: add getregion() function echo has("patch-9.1.0127")
function M.get_visual_selection()
    local _, ls, cs = unpack(vim.fn.getpos("v"))
    local _, le, ce = unpack(vim.fn.getpos("."))
    local result = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1]

    return result
end

function M.printCallerInfo(f)
    f = f or 3
    local info = debug.getinfo(f, "Sl")
    if info then
        print("Called from: " .. (info.short_src or "unknown source")
            .. " :" .. (info.currentline or "unknown line"))
    else
        print("No caller information available.")
    end
end

function M.contains(tbl, str)
    for _, v in ipairs(tbl) do
        if v == str then
            return true
        end
    end
    return false
end

function M.run_ansiesc_in_qf()
    local curwin = vim.api.nvim_get_current_win()
    local qf_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "quickfix" then
            qf_win = win
            break
        end
    end
    if not qf_win then
        print("No quickfix window found")
        return
    end
    vim.api.nvim_set_current_win(qf_win)
    vim.cmd("AnsiEsc")
    vim.api.nvim_set_current_win(curwin)
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
    g.gencconf_default_option = vim.tbl_deep_extend("force", M.option.gencconf_default_option,
        Option.gencconf_default_option)
    --vim.print(g.gencconf_default_option)

    -- require("plugins.telescope").telescope_update_ignore()
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
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            local client = clients[next(clients)]

            if client ~= nil then
                local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
                ---@diagnostic disable-next-line
                local ret = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 1000)

                --vim.print(ret)
                if ret ~= nil and next(ret) then
                    local result = ret[next(ret)].result or {}
                    if #result == 1 then
                        vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })

                        -- if not jump, fallback ltag
                        if bufnr ~= fn.bufnr() or lnum ~= fn.line(".") then
                            return
                        end
                    elseif #result > 1 then
                        Snacks.picker.lsp_definitions()
                        return
                    end
                end
            end
        end

        -- fallback ltag
        local backup = vim.o.tagfunc
        vim.o.tagfunc = ""
        pcall(fn.execute, "silent ltag " .. str)

        if fn.getloclist(0, { size = 0 }).size > 1 then
            -- if resut > 1, not auto jump
            M.ltaglist()
        end
        vim.o.tagfunc = backup
    end
end

function M.findFile()
    require("plugins.snacks").findFile()
end

function M.grep()
    require("plugins.snacks").grep()
end

function M.ltaglist()
    -- require("plugins.telescope").telescope_ltaglist()
    require("plugins.snacks").ltaglist()
end

-- tags ltag {{{
vim.cmd([[ set tags=tags,tags; ]])
function M.removetags()
    cmd("ClearClangConf")
    cmd("ClearCtags")
end

function M.lspRestart()
    if vim.fn.exists(":LspRestart") ~= 0 then
        cmd("LspRestart")
    end
end

function M.gentags(type)
    type = type or 0
    cmd("ClearClangConf")
    cmd("GenClangConf")
    M.lspRestart()
    if type == 0 then
        cmd("GenCtags")
    end
end

-- fork from vim.show_pos
function M.get_cursor_highlight_color()
    local curBuf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line, col = cursor[1] - 1, cursor[2]
    local items = vim.inspect_pos(curBuf, line, col)

    local lines = { {} }
    local function append(str, hl)
        table.insert(lines[#lines], { str, hl })
    end
    local function nl()
        table.insert(lines, {})
    end
    local function item(data, comment)
        append("  - ")
        append(data.hl_group, data.hl_group)
        append(" ")
        if data.hl_group ~= data.hl_group_link then
            append("links to ", "MoreMsg")
            append(data.hl_group_link, data.hl_group_link)
            append("   ")
            local hl = vim.api.nvim_get_hl(0, { name = data.hl_group_link })
            local str = vim.inspect(hl):gsub("\n", " ")
            append(str)
            append("   ")
        end
        if comment then
            append(comment, "Comment")
        end
        nl()
    end

    -- print(vim.inspect(result))
    if #items.syntax > 0 then
        append("Syntax", "Title")
        nl()
        for _, syn in ipairs(items.syntax) do
            item(syn)
        end
        nl()
    end

    if #items.treesitter > 0 then
        append("Treesitter", "Title")
        nl()
        for _, capture in ipairs(items.treesitter) do
            item(
                capture,
                string.format(
                    "priority: %d   language: %s",
                    capture.metadata.priority or vim.hl.priorities.treesitter,
                    capture.lang
                )
            )
        end
        nl()
    end

    if #items.semantic_tokens > 0 then
        append("Semantic Tokens", "Title")
        nl()
        local sorted_marks = vim.fn.sort(items.semantic_tokens, function(left, right)
            local left_first = left.opts.priority < right.opts.priority
                or left.opts.priority == right.opts.priority and left.opts.hl_group < right.opts.hl_group
            return left_first and -1 or 1
        end)
        for _, extmark in ipairs(sorted_marks) do
            item(extmark.opts, "priority: " .. extmark.opts.priority)
        end
        nl()
    end

    if #items.extmarks > 0 then
        append("Extmarks", "Title")
        nl()
        for _, extmark in ipairs(items.extmarks) do
            if extmark.opts.hl_group then
                item(extmark.opts, extmark.ns)
            else
                append("  - ")
                append(extmark.ns, "Comment")
                nl()
            end
        end
        nl()
    end

    if #lines[#lines] == 0 then
        table.remove(lines)
    end

    local chunks = {}
    for _, l in ipairs(lines) do
        vim.list_extend(chunks, l)
        table.insert(chunks, { "\n" })
    end
    if #chunks == 0 then
        chunks = {
            {
                "No items found at position "
                .. items.row
                .. ","
                .. items.col
                .. " in buffer "
                .. items.buffer,
            },
        }
    end
    vim.api.nvim_echo(chunks, false, {})
end

M.map("n", "ta", "<cmd>lua require('util').gentags()<CR>")
M.map("n", "tc", "<cmd>lua require('util').gentags(1)<CR>")
M.map("n", "tr", "<cmd>lua require('util').removetags()<CR>")

M.map("n", "<leader>gc", "<cmd>lua require('util').get_cursor_highlight_color()<CR>")
M.map("n", "<leader>ra", "<cmd>lua require('util').run_ansiesc_in_qf()<CR>")

return M
