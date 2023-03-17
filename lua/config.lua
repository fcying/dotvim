local M = {}

local map = require("util").map
local g, cmd, fn = vim.g, vim.cmd, vim.fn

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
            ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
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
                    vsnip = "[Snip]",
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

    cmp.setup.cmdline("/", {
        sources = {
            { name = "buffer" },
        },
    })

    cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
        }),
    })

    local dict = require("cmp_dictionary")
    local dict_path = g.config_dir .. "/dict/"
    dict.setup({
        exact = 2,
        first_case_insensitive = false,
        document = false,
        document_command = "wn %s -over",
        async = false,
        sqlite = false,
        max_items = -1,
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

function M.lualine()
    local theme = "auto"
    if vim.g.colors_name == "solarized8" then
        theme = "solarized"
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
            lualine_x = { "encoding", "fileformat", "filetype" },
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
    cmd([[
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

function M.easymotion()
    vim.cmd([[
        let g:EasyMotion_smartcase = 0
        let g:EasyMotion_do_mapping = 0   " Disable default mappings
        " move to {char}
        nmap s <Plug>(easymotion-overwin-f)
        " move to {char}{char}
        nmap S <Plug>(easymotion-overwin-f2)
        " Move to line
        nmap L <Plug>(easymotion-overwin-line)
        " Move to word
        "nmap <Leader>w <Plug>(easymotion-overwin-w)
    ]])
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
    vim.cmd([[
        " set default delimiter
        set commentstring=#%s
        let g:NERDCreateDefaultMappings = 0
        let g:NERDSpaceDelims = 0
        "let g:NERDRemoveExtraSpaces = 0
        let g:NERDCommentEmptyLines = 1
        let g:NERDDefaultAlign = 'left'
        let g:NERDToggleCheckAllLines = 1
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
        nmap <A-/> <plug>NERDCommenterToggle
        vmap <A-/> <plug>NERDCommenterToggle gv
        nmap <leader>gc <plug>NERDCommenterToggle
        vmap <leader>gc <plug>NERDCommenterToggle
        vmap <leader>gC <plug>NERDCommenterComment
        vmap <leader>gU <plug>NERDCommenterUncomment
        nmap <leader>gi <plug>NERDCommenterInvert
        vmap <leader>gi <plug>NERDCommenterInvert
        nmap <leader>gs <plug>NERDCommenterSexy
        vmap <leader>gs <plug>NERDCommenterSexy
    ]])
end

M.is_init = false
function M.init()
    if not M.is_init then
        M.is_init = true

        require("globals")

        vim.cmd([[
        let g:pvimrc_path = findfile('.pvimrc', g:root_marker . ';' . g:root_marker . '..')
        if g:pvimrc_path !=# ''
        "exec 'sandbox source ' . g:pvimrc_path
        exec 'source ' . g:pvimrc_path
        else
        let g:pvimrc_path = g:root_marker . '/.pvimrc'
        endif
        ]])

        require("autocmds")
        require("options")
        require("keymaps")

        M.gen_clang_conf()

        require("plugins.lazy")

        cmd.colorscheme("solarized8")
        vim.opt.background = "light"
    end
end

return M
