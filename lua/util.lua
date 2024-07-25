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
    clangd_query_driver = nil,
    asyncrun_auto_close_qf = false,
    build = function() return { cmd = "", name = "Build Task", } end,
    release = function() return { cmd = "", name = "Release Task", } end,
}
local option_default = {
    -- ignore list
    dir = { ".root", ".svn", ".git", ".repo", ".ccls-cache", ".cache", ".ccache" },
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

-- FIXME add getregion() function echo has("patch-9.1.0127")
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

function M.find_file()
    fn.execute(M.find_command)
end

function M.live_grep()
    if vim.api.nvim_get_mode().mode == "v" then
        require("telescope-live-grep-args.shortcuts").grep_visual_selection()
    else
        --require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
        require("telescope").extensions.live_grep_args.live_grep_args()
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
    g.gencconf_default_option = vim.tbl_deep_extend("force", M.option.gencconf_default_option,
        Option.gencconf_default_option)
    --vim.print(g.gencconf_default_option)

    require("plugins._telescope").telescope_update_ignore()
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

            require("plugins._telescope").telescope_ltaglist()
        end
        vim.o.tagfunc = backup
    end
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
