local M = {}

local util = require("util")
local map = util.map
local g, fn = vim.g, vim.fn

-- plugin load config before autoload
local pre_config = {
    "gen_clang_conf",
    "asyncrun",
    "asynctasks",
    "nerdcommenter",
    "foldsearch",
    "ZFVimIM",
}

function M.fugitive()
    g.flog_default_opts = {
        max_count = 2000,
        merges = 0,
        date = "format:%Y-%m-%d %H:%M",
    }

    local function GFileEdit(mode, history)
        history = history or false
        mode = mode or "edit"
        local result = ""
        local run = ""
        if vim.bo.filetype == "git" then
            result = fn["fugitive#Cfile"]()
            --print(vim.inspect(result))
            if #result > 0 then
                if string.match(result, "+Gdiffsplit") then
                    run = "G" .. mode .. " " .. result
                elseif string.match(result, "fugitive://") then
                    if history == false then
                        -- edit origin file
                        result = string.gsub(result, "fugitive://", "", 1)
                        result = string.gsub(result, ".git//.-/", "", 1)
                    end
                    run = "G" .. mode .. " " .. result
                end
                print(run)
                if run ~= "" then
                    vim.cmd(run)
                end
            end
        end
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("Flog", { clear = true }),
        pattern = { "git", "floggraph" },
        callback = function()
            g.flog_enable_status = true
            local opts = { buffer = vim.api.nvim_get_current_buf() }
            map("n", "e", function() GFileEdit("edit") end, opts)
            map("n", "ge", function() GFileEdit("edit", true) end, opts)
            map("n", "<c-t>", function() GFileEdit("tabedit") end, opts)
            map("n", "<CR>", "<Plug>(FlogVSplitCommitRight) <BAR> :wincmd w<cr>", opts)
            map("n", "<c-n>", ":wincmd w<cr> <BAR> <Plug>(FlogVNextCommitRight) <BAR> :wincmd w<cr>", opts)
            map("n", "<c-p>", ":wincmd w<cr> <BAR> <Plug>(FlogVPrevCommitRight) <BAR> :wincmd w<cr>", opts)
            map("n", "gs", "<Plug>(FlogVSplitStaged) <BAR> :wincmd w<cr>", opts)
            map("n", "gu", "<Plug>(FlogVSplitUntracked) <BAR> :wincmd w<cr>", opts)
            map("n", "gU", "<Plug>(FlogVSplitUnstaged) <BAR> :wincmd w<cr>", opts)
        end,
    })
end

function M.asyncrun()
    g.asyncrun_bell = 1
    g.asyncrun_silent = 0
    g.asyncrun_open = 6
    vim.api.nvim_create_autocmd("User", {
        group = "myau",
        pattern = { "AsyncRunStop" },
        callback = function()
            if g.asyncrun_code == 0 then
                vim.cmd("cclose")
                vim.print("AsyncRun Success")
            else
                --call ShowQuickfix()
                vim.cmd("copen")
                vim.cmd("cnext")
            end
        end,
    })
end

function M.asynctasks()
    g.asyncrun_rootmarks = { ".root", ".git", ".svn" }
    g.asynctasks_config_name = { ".root/.tasks", ".git/.tasks", ".tasks" }
    g.asynctasks_rtp_config = "asynctasks.ini"
    map("n", "<leader>bb", ":AsyncTask build<CR>")
    map("n", "<leader>br", ":AsyncTask release<CR>")
end

function M.sandwich()
    vim.cmd([[
    let g:sandwich_no_default_key_mappings = 1
    let g:textobj_sandwich_no_default_key_mappings = 1
    let g:operator_sandwich_no_default_key_mappings = 1
    nmap <leader>srb <Plug>(operator-sandwich-replace)
    \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
    nmap <leader>sdb <Plug>(operator-sandwich-delete)
    \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
    nmap <leader>sr <Plug>(operator-sandwich-replace)
    \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    nmap <leader>sd <Plug>(operator-sandwich-delete)
    \<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
    xmap <leader>sr <Plug>(operator-sandwich-replace)
    xmap <leader>sd <Plug>(operator-sandwich-delete)
    omap <leader>sa <Plug>(operator-sandwich-g@)
    xmap <leader>sa <Plug>(operator-sandwich-add)
    nmap <leader>sa <Plug>(operator-sandwich-add)
    ]])
end

function M.tagbar()
    vim.cmd([[
    nnoremap <silent><Leader>wt :TagbarToggle<CR>
    nnoremap <silent><F11> :TagbarToggle<CR>
    let g:tagbar_width=32
    let g:tagbar_compact=1
    let g:tagbar_type_vim = {
        \ 'ctagstype' : 'vim',
        \ 'kinds' : [
        \ 'p:plugin_setting',
        \ 'f:functions',
        \ ]
        \ }
        let g:tagbar_type_sh = {
            \ 'ctagstype' : 'sh',
            \ 'kinds' : [
            \ 'i:if_condition',
            \ 'f:functions',
            \ ]
            \ }
            ]])
end

function M.treesitter()
    local parser_install_dir = g.runtime_dir .. "/parsers"
    vim.opt.runtimepath:prepend(parser_install_dir)
    require("nvim-treesitter.configs").setup {
        parser_install_dir = parser_install_dir,
        ensure_installed = {
            "vim", "vimdoc", "lua", "query",
            "bash", "regex", "markdown", "markdown_inline",
            "cpp",
        },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        matchup = { enable = true },
        highlight = {
            enable = false,
            additional_vim_regex_highlighting = false,
            disable = function(lang, buf)
                local disable_hl = { "help", "lua", "cpp", "c" }
                for _, l in ipairs(disable_hl) do
                    if l == lang then
                        return true
                    end
                end
                local max_filesize = 100 * 1024
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
    }
end

function M.nt_cpp_tools()
    require "nt-cpp-tools".setup({
        preview = {
            quit = "q",
            accept = "<tab>"
        },
        header_extension = "h",
        source_extension = "cpp",
    })
end

function M.luasnip()
    local paths = {}
    paths[#paths + 1] = g.config_dir .. "/snippets"
    paths[#paths + 1] = g.plug_dir .. "/friendly-snippets"
    require("luasnip.loaders.from_vscode").lazy_load({ paths = paths })

    vim.cmd([[
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
    " -1 for jumping backwards.
    inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

    snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
    snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

    " For changing choices in choiceNodes (not strictly necessary for a basic setup).
    imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    ]])
end

function M.cmp()
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        preselect = cmp.PreselectMode.None,
        mapping = {
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-l>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
        },
        sources = cmp.config.sources({
            { name = "luasnip" },
            { name = "path" },
            { name = "dictionary" },
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "tags" },
            { name = "omni", priority = -1 },
        }),
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = ({
                    buffer = "[Buf]",
                    path = "[Path]",
                    cmdline = "[Cmd]",
                    nvim_lsp = "[Lsp]",
                    tags = "[Tag]",
                    tmux = "[Tmux]",
                    luasnip = "[Snip]",
                    dictionary = "[Dict]",
                    omni = "[Omni]",
                    cmdline_history = "[History]",
                })[entry.source.name]
                vim_item.dup = ({
                    nvim_lsp = 0,
                    buffer = 1,
                    path = 1,
                })[entry.source.name] or 0
                return vim_item
            end,
        },
    })

    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "buffer" },
        }),
    })

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "buffer" },
            { name = "cmdline_history" },
        }),
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
            { name = "cmdline_history" },
        }),
    })
end

function M.cmp_dictionary()
    local dict_path = g.config_dir .. "/dict/"
    local dict = {
        ["*"] = { dict_path .. "dictionary" },
        ["xmake"] = { dict_path .. "xmake.dict" },
        ["go"] = { dict_path .. "go.dict" },
    }

    local function get_dict_path(file)
        local paths = {}
        if file:find(".*xmake.lua") then
            paths = dict.xmake
        else
            paths = dict[vim.bo.filetype] or {}
        end
        vim.list_extend(paths, dict["*"])
        --vim.notify(vim.inspect(paths))
        return paths
    end

    require("cmp_dictionary").setup({
        paths = get_dict_path(fn.expand("%")),
        exact_length = 2,
        first_case_insensitive = false,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(ev)
            require("cmp_dictionary").setup({ paths = get_dict_path(ev.file) })
        end,
    })
end

function M.dashboard()
    --- @format disable-next
    local opts = {
        theme = "doom",
        hide = { statusline = false },
        config = {
            header = require("ascii_logo").neovim1,
            center = {
                { action = "ene | startinsert",                     desc = " New file",        icon = " ", key = "n" },
                { action = "lua require('util').find_file()",       desc = " Find file",       icon = " ", key = "ff" },
                { action = "Telescope live_grep",                   desc = " Find text",       icon = " ", key = "f/" },
                { action = "Telescope oldfiles",                    desc = " Recent files",    icon = " ", key = "fm" },
                { action = "lua require('persistence').load()",     desc = " Restore Session", icon = " ", key = "s" },
                { action = "Lazy",                                  desc = " Lazy",            icon = "󰒲 ", key = "l" },
                { action = "qa",                                    desc = " Quit",            icon = " ", key = "q" },
            },
            footer = function()
                local version = vim.version().major .. "." .. vim.version().minor .. vim.version().patch
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                return { "Neovim-" .. version .. " loaded " .. stats.loaded .. "/"
                .. stats.count .. " plugins in " .. ms .. "ms" }
            end,
        },
    }

    for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
    end

    require("dashboard").setup(opts)
end

function M.lualine()
    local s = require("statusline")
    local theme = "auto"
    require("lualine").setup({
        tabline = {},
        extensions = {},
        options = {
            --globalstatus = true,
            always_divide_middle = true,
            component_separators = {
                left = "|",
                right = "|",
            },
            disabled_filetypes = {},
            icons_enabled = false,
            section_separators = {
                left = "",
                right = "",
            },
            theme = theme,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { s.git_status, "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = {
                s.lsp_progress,
                --s.search,
                --s.macro_recording,
                "fileformat",
                s.fileencoding,
                "filetype",
                s.indent,
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
    })
end

function M.noice()
    return {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = false,
                long_message_to_split = true,
                inc_rename = true,
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
        },
        keys = {
            { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
            { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
            { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" } },
            { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" } },
        },
        dependencies = {
            { "MunifTanjim/nui.nvim" },
        }
    }
end

function M.notify()
    vim.notify = require("notify")
    _G.print = function(...)
        local print_safe_args = {}
        local _ = { ... }
        for i = 1, #_ do
            table.insert(print_safe_args, tostring(_[i]))
        end
        local msg = table.concat(print_safe_args, " ")
        vim.notify(msg, vim.log.levels.INFO)
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

    -- FIXME add wrap or fix wrapped-compact format
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
end

function M.marks()
    map("n", "<leader>ml", "<cmd>Telescope marks<CR>")
    map("n", "dm<space>", "<cmd>delm!<CR>")
    require("marks").setup({
        default_mappings = true,
        builtin_marks = {},
        cyclic = true,
        force_write_shada = true,
        refresh_interval = 250,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = {},
        bookmark_0 = {
            sign = "⚑",
            virt_text = "",
        },
        mappings = {},
    })
end

function M.gen_clang_conf()
    vim.cmd([[
        let g:gencconf_storein_rootmarker = get(g:,'gencconf_storein_rootmarker',1)
    ]])
end

function M.lastplace()
    require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
    }
end

function M.vim_expand_region()
    vim.cmd([[
        xmap v <Plug>(expand_region_expand)
        xmap V <Plug>(expand_region_shrink)
        let g:expand_region_text_objects = {
                \ 'iw'  :0,
                \ 'iW'  :0,
                \ 'i"'  :0,
                \ 'i''' :0,
                \ 'i]'  :1,
                \ 'ib'  :1,
                \ 'iB'  :1,
                \ 'il'  :1,
                \ 'ii'  :1,
                \ 'ip'  :0,
                \ 'ie'  :0,
                \ }
    ]])
end

function M.foldsearch()
    vim.cmd([[
        let g:foldsearch_highlight = 1
        let g:foldsearch_disable_mappings = 0

        nmap <Leader>fp :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
        xmap <Leader>fp :<C-u><C-R>=printf("Fp %s", expand("<cword>"))<CR>
    ]])
end

function M.nerdcommenter()
    vim.opt.commentstring = "#%s"
    g.NERDCreateDefaultMappings = 0
    g.NERDSpaceDelims = 0
    --g.NERDRemoveExtraSpaces = 0
    g.NERDCommentEmptyLines = 1
    g.NERDDefaultAlign = "left"
    g.NERDToggleCheckAllLines = 1

    map("n", "<a-/>", "<plug>NERDCommenterToggle", { desc = "NERDCommenterToggle" })
    map("v", "<a-/>", "<plug>NERDCommenterToggle", { desc = "NERDCommenterToggle" })
    map("n", "<leader>gc", "<plug>NERDCommenterToggle", { desc = "NERDCommenterToggle" })
    map("v", "<leader>gc", "<plug>NERDCommenterToggle", { desc = "NERDCommenterToggle" })
    map("v", "<leader>gC", "<plug>NERDCommenterComment", { desc = "NERDCommenterComment" })
    map("v", "<leader>gU", "<plug>NERDCommenterUncomment", { desc = "NERDCommenterUncomment" })
    map("n", "<leader>gi", "<plug>NERDCommenterInvert", { desc = "NERDCommenterInvert" })
    map("v", "<leader>gi", "<plug>NERDCommenterInvert", { desc = "NERDCommenterInvert" })
    map("n", "<leader>gs", "<plug>NERDCommenterSexy", { desc = "NERDCommenterSexy" })
    map("v", "<leader>gs", "<plug>NERDCommenterSexy", { desc = "NERDCommenterSexy" })
    vim.cmd([[
        let g:NERDCustomDelimiters = {
                \ 'c': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'cpp': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'go': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'qml': { 'leftAlt': '/*', 'rightAlt': '*/', 'left': '//' },
                \ 'conf': { 'left': '#' },
                \ 'aptconf': { 'left': '//' },
                \ 'json': { 'left': '//' },
                \ 'jsonc': { 'left': '//' },
                \ 'rc': { 'left': '#' },
                \ '*': { 'left': '#' },
                \ }
    ]])
end

function M.fern()
    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "fern",
        group = vim.api.nvim_create_augroup("fern_init", { clear = true }),
        callback = function()
            vim.cmd([[
            nmap <buffer><expr>
            \ <Plug>(fern-my-open-or-expand-or-collapse)
            \ fern#smart#leaf(
            \   "\<Plug>(fern-action-open)",
            \   "\<Plug>(fern-action-expand)",
            \   "\<Plug>(fern-action-collapse)",
            \ )
            nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-or-expand-or-collapse)
            nmap <buffer> <enter> <Plug>(fern-my-open-or-expand-or-collapse)
            nmap <buffer> t <Plug>(fern-action-open:tabedit)
            nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
            nmap <buffer> i <Plug>(fern-action-open:split)
            nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
            nmap <buffer> s <Plug>(fern-action-open:vsplit)
            nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p

            nmap <buffer> E <Plug>(fern-action-enter)
            nmap <buffer> u <Plug>(fern-action-leave)
            nmap <buffer> r <Plug>(fern-action-reload)
            nmap <buffer> d <Plug>(fern-action-remove)
            nmap <buffer> q :<C-u>quit<CR>
            ]])
        end,
    })
end

function M.whichkey()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
    local wk = require("which-key")
    wk.setup({
        triggers = { "<leader>", "g", "f" }, -- specifiy a list or auto
    })
    wk.register({
        f = { name = "telescope" },
    })
    wk.register({
        c = { name = "cd ..." },
        d = { name = "delete ..." },
        e = { name = "edit ..." },
        g = { name = "nerdcommenter" },
        l = { name = "lsp" },
        m = { name = "mark" },
        s = { name = "sandwich | noice" },
        p = { name = "plugin" },
        t = { name = "tab" },
        w = { name = "window" },
    }, { prefix = "<leader>" })
    wk.register({
        n = { name = "noice" },
    }, { prefix = "<leader>s" })
end

function M.ZFVimIM()
    g.ZFVimIM_cachePath = g.runtime_dir .. g.dir_separator .. "ZFVimIM"
    g.ZFVimIM_cloudAsync_outputTo = {
        outputType = "statusline",
        outputId = "ZFVimIM_cloud_async",
    }
    g.ZFJobVerboseLogEnable = 0

    local db_file = "vim_wubi.txt"
    local repo_path
    if g.is_win == 1 then
        repo_path = "d:/sync/tool/rime"
    else
        repo_path = vim.fn.expand("~/sync/tool/rime")
    end
    if vim.loop.fs_stat(repo_path .. "/" .. db_file) then
        local function db_init()
            local db = vim.fn.ZFVimIM_dbInit({ name = "custom", editable = 0, priority = 200 })
            vim.fn.ZFVimIM_cloudRegister({
                mode = "local",
                dbId = db["dbId"],
                repoPath = repo_path,
                dbFile = db_file,
            })
        end
        vim.api.nvim_create_autocmd("User", {
            group = vim.api.nvim_create_augroup("ZFVimIM_custom_augroup", { clear = true }),
            pattern = { "ZFVimIM_event_OnDbInit" },
            callback = function() db_init() end
        })
    end
end

local init_done = false
function M.setup()
    if init_done then
        return
    end
    init_done = true

    util.get_root_marker({ ".root", ".git", ".repo", ".svn" })
    require("project_config").setup()
    require("settings")
    require("keymaps")

    for _, v in pairs(pre_config) do
        M[v]()
    end

    require("plugins.lazy")
    vim.opt.background = "light"
    vim.cmd.colorscheme("solarized")
    --vim.cmd.colorscheme("tokyonight-day")

    util.update_ignore_config()
end

return M
