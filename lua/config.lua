local M = {}

local util = require("util")
local map = util.map
local g, fn, cmd = vim.g, vim.fn, vim.cmd

-- plugin load config before autoload
local pre_config = {
    "project_config",
    "gen_clang_conf",
    "asyncrun",
    "asynctasks",
    "nerdcommenter",
    "foldsearch",
}

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
    map("n", "<leader>b", ":AsyncTask build<CR>")
end

function M.luasnip()
    local paths = {}
    paths[#paths + 1] = g.config_dir .. "/snippets"
    paths[#paths + 1] = g.config_dir .. "/.plugged/friendly-snippets"
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

function M.treesitter()
    local parser_install_dir = g.runtime_dir .. "/parsers"
    vim.opt.runtimepath:prepend(parser_install_dir)
    require("nvim-treesitter.configs").setup {
        parser_install_dir = parser_install_dir,
        ensure_installed = { "cpp", "lua" },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        highlight = {
            enable = false,
            disable = { 'help' },
            additional_vim_regex_highlighting = false,
        },
        matchup = { enable = false },
    }
end

function M.nt_cpp_tools()
    require 'nt-cpp-tools'.setup({
        preview = {
            quit = 'q',
            accept = '<tab>'
        },
        header_extension = 'h',
        source_extension = 'cpp',
    })
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
            { name = "omni",      priority = -1 },
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

    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            { name = "buffer" },
        }),
    })

    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "buffer" },
        }),
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
    })

    --FIXME need update to v3
    local dict = require("cmp_dictionary")
    local dict_path = g.config_dir .. "/dict/"
    dict.setup({
        exact_length = 2,
        first_case_insensitive = false,
        document = false,
        document_command = "wn %s -over",
        sqlite = false,
        max_number_items = -1,
        capacity = 5,
        debug = false,
    })
    dict.switcher({
        filetype = {
            go = { dict_path .. "go.dict" },
        },
        filepath = {
            [".*"] = { dict_path .. "dictionary" },
            [".*xmake.lua"] = { dict_path .. "xmake.dict" },
        },
    })
end

function M.lualine()
    local theme = "auto"
    if vim.g.colors_name == "solarized8" then
        theme = "solarized"
    end

    local function ext_encoding()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.bo[bufnr].bomb then
            return string.format("%s-bom", vim.bo[bufnr].fileencoding)
        else
            return vim.bo[bufnr].fileencoding
        end
    end

    require("lualine").setup({
        extensions = {},
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
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
            lualine_b = { "diff", "diagnostics" },
            --lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { "filename" },
            lualine_x = { ext_encoding, "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        tabline = {},
    })
end

function M.notify()
    require("notify").setup({
        -- fade_in_slide_out fade slide static
        stages = "fade_in_slide_out",
        on_open = nil,
        on_close = nil,
        render = "default",
        timeout = 5000,
        background_colour = "Normal",
        minimum_width = 50,
        icons = {
            ERROR = "E",
            WARN = "W",
            INFO = "I",
            DEBUG = "D",
            TRACE = "T",
        },
    })
    vim.cmd([[
        highlight NotifyINFOIcon guifg=#009f9f
        highlight NotifyINFOTitle guifg=#009f9f
    ]])
    vim.notify = require("notify")
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
        let g:gencconf_ctags_option = '--languages=c++ --languages=+c'
        if !exists('g:gencconf_default_option')
            let g:gencconf_default_option = {
                \ 'c': ['gcc', '-c', '-std=c11'],
                \ 'cpp': ['g++', '-c', '-std=c++14'],
                \ '*': ['-ferror-limit=0']
                \ }
        endif
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
    vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = 'fern',
        group = vim.api.nvim_create_augroup('fern_init', { clear = true }),
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
        p = { name = "plugin" },
        t = { name = "tab" },
        w = { name = "window" },
    }, { prefix = "<leader>" })
end

function M.project_config()
    g.pvimrc_path = fn.findfile('.pvimrc', g.root_marker .. ';' .. g.root_marker .. '..')
    if g.pvimrc_path ~= '' then
        cmd.source(g.pvimrc_path)
    else
        g.pvimrc_path = g.root_marker .. '/.pvimrc'
    end
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = "myau",
        pattern = { ".pvimrc" },
        callback = function()
            cmd("source " .. g.pvimrc_path)
        end,
        nested = true,
    })
    vim.api.nvim_create_autocmd("SourcePost", {
        group = "myau",
        pattern = { ".pvimrc" },
        callback = function()
            util.update_ignore_config()
        end,
    })
end

M.is_init = false
function M.init()
    if not M.is_init then
        M.is_init = true

        require("globals")
        require("keymaps")

        for _, v in pairs(pre_config) do
            M[v]()
        end

        vim.opt.background = "light"

        require("plugins.lazy")

        vim.cmd.colorscheme("solarized8")
    end
end

return M
