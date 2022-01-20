local M = {}

local map = require('remap').map
local g, cmd, fn, api = vim.g, vim.cmd, vim.fn, vim.api

--for test
--fn.writefile(fn.split(vim.inspect(_G),'\n'),g.cache_dir .. '/log','')

function M.packer()
    cmd('packadd packer.nvim')

    local function conf(name)
        return string.format("require('config').%s()", name)
    end
    local packer = require('packer')
    local use = packer.use

    packer.init({
        package_root = g.plug_dir .. '/pack',
        compile_path = g.plug_dir .. '/plugin/packer_compiled.lua',
        plugin_package = 'packer',
        auto_clean = false,
    })

    use({ 'wbthomason/packer.nvim', opt = true })
    for _, value in ipairs(g.plug_options) do
        local options = { value[1] }
        if value[2] ~= 'nil' then
            for k, v in pairs(value[2]) do
                options[k] = v
            end
            if value[2]['run'] ~= nil then
                local s = value[2]['run']
                if string.find(s, '^function') == nil then
                    options['run'] = s
                else
                    options['run'] = function()
                        fn[string.match(s, "function%('(.-)'%)")](0)
                    end
                end
            end
            if value[2]['config'] ~= nil then
                options['config'] = conf(value[2]['config'])
            end
        end
        options['opt'] = true
        use(options)
        --print(vim.inspect(options))
    end

    if g.plug_need_update == 1 or g.force_update == 1 then
        packer.sync()
    else
        if fn.filereadable(g.plug_dir .. '/plugin/packer_compiled.lua') == 0 then
            packer.compile()
        end
    end
end

function Go2Def(str, mode)
    if vim.o.filetype == 'help' then
        pcall(fn.execute, 'tag ' .. str)
    else
        if mode == 1 then
            local params = vim.lsp.util.make_position_params()
            local ret = vim.lsp.buf_request(0, 'textDocument/definition', params, function() end)
            if next(ret) ~= nil then
                require('telescope.builtin').lsp_definitions()
                return
            end
        end

        local bufnr = fn.bufnr()
        local lnum = fn.line('.')

        local ret = pcall(fn.execute, 'silent ltag ' .. str)
        local loc_size = fn.getloclist(0, { size = 0 }).size

        if loc_size > 1 and ret == true then
            -- if resut > 1, not auto jump
            if bufnr ~= fn.bufnr() then
                fn.execute('buf ' .. bufnr)
            end
            if lnum ~= fn.line('.') then
                vim.cmd('normal ' .. lnum .. 'G^')
            end

            require('telescope.builtin').loclist()
        end
    end
end

function M.telescope_map()
    if fn.HasPlug('LeaderF') == -1 then --{{{
        map('n', 'fm', '<cmd>Telescope oldfiles<cr>')
        map('n', 'fb', '<cmd>Telescope buffers<cr>')
        map('n', 'fl', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
        map('n', 'fh', '<cmd>Telescope help_tags<cr>')
        map('n', 'ft', '<cmd>Telescope tags<cr>')
        map('n', 'fj', '<cmd>Telescope jumplist<cr>')
        map('n', 'fr', '<cmd>Telescope resume<cr><tab>')
        map('n', 'f/', '<cmd>Telescope live_grep<cr>')
        map('n', 'fg', '<cmd>Telescope grep_string<cr>')
        cmd([[
            vnoremap fg :<C-u>lua require("telescope.builtin.files").grep_string({search="<C-R>=GetVisualSelection()<CR>"})
            nnoremap <silent>ff :<C-u><C-R>=g:find_command<CR><CR>
        ]])
    end
    map('n', 'fo', '<cmd>Telescope ctags_outline outline<cr>')
    map('n', 'fn', '<cmd>Telescope notify<cr>')

    -- goto def
    map('n', 'g<c-]>', '<c-]>')
    map('v', 'g<c-]>', '<c-]>')
    map('n', '<c-]>', ':lua Go2Def(vim.fn.expand("<cword>"), 0)<cr>')
    map('v', '<c-]>', ':<c-u>lua Go2Def(vim.fn.GetVisualSelection(), 0)<cr>')
    map('n', 'gd', ':lua Go2Def(vim.fn.expand("<cword>"), 1)<cr>')

    --map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>')
    map('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>')
    map('n', '<leader>lt', '<cmd>Telescope lsp_type_definitions<cr>')
    map('n', '<leader>li', '<cmd>Telescope lsp_implementations<cr>')
    map('n', '<leader>la', '<cmd>Telescope lsp_code_actions<cr>')
    map('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<cr>')
    map('n', '<leader>le', '<cmd>Telescope diagnostics bufnr=0<cr>')
    map('n', '<leader>lo', '<cmd>Telescope ctags_outline outline<cr>')
end
function M.telescope_update_ignore()
    g.find_command = 'Telescope find_files '
    if g.has_rg == 1 then
        g.find_command = g.find_command .. 'find_command=rg,--files,--color=never'
        if g.ignore_full.rg then
            g.find_command = g.find_command .. ',' .. table.concat(g.ignore_full.rg, ',')
        end
    end

    if _G['TelescopeGlobalState'] ~= nil then
        local conf = require('telescope.config').values
        conf.vimgrep_arguments = {
            'rg',
            '--color=never',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
        }
        for _, v in ipairs(g.ignore_full.rg) do
            table.insert(conf.vimgrep_arguments, v)
        end
    end
end
function M.telescope()
    local actions = require('telescope.actions')
    local toggle_modes = function()
        local mode = api.nvim_get_mode().mode
        if mode == 'n' then
            cmd([[startinsert]])
            return
        elseif mode == 'i' then
            cmd([[stopinsert]])
            return
        end
    end
    require('telescope').setup({
        defaults = {
            --horizontal vertical flex center
            layout_strategy = 'vertical',
            mappings = {
                i = {
                    ['<esc>'] = actions.close,
                    ['<c-j>'] = actions.move_selection_next,
                    ['<c-k>'] = actions.move_selection_previous,
                    ['<tab>'] = toggle_modes,
                    ['<c-s>'] = actions.toggle_selection,
                    ['<C-q>'] = actions.send_to_qflist.open_qflist,
                },
                n = {
                    ['<tab>'] = toggle_modes,
                    ['<c-s>'] = actions.toggle_selection,
                    ['<C-q>'] = actions.send_to_qflist.open_qflist,
                },
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                -- smart_case ignore_case respect_case
                case_mode = 'smart_case',
            },
            ctags_outline = {
                ctags = { 'ctags', g.ctags_opt },
                ft_opt = {
                    vim = '--vim-kinds=fk',
                    sh = '--sh-kinds=fk',
                    zsh = '--sh-kinds=fk',
                    lua = '--lua-kinds=fk',
                },
            },
        },
    })
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ctags_outline')
    M.telescope_update_ignore()
end

function M.cmp()
    cmd([[autocmd myau BufEnter * setl omnifunc=syntaxcomplete#Complete]])
    local cmp = require('cmp')
    cmp.setup({
        preselect = cmp.PreselectMode.None,
        mapping = {
            ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        },
        snippet = {
            expand = function(args)
                fn['vsnip#anonymous'](args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = 'vsnip' },
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'dictionary' },
            { name = 'cmdline' },
            { name = 'buffer' },
            { name = 'tags' },
            { name = 'omni', priority = -1 },
        }),
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = ({
                    buffer = '[Buf]',
                    path = '[Path]',
                    cmdline = '[Cmd]',
                    nvim_lsp = '[Lsp]',
                    tags = '[Tag]',
                    tmux = '[Tmux]',
                    vsnip = '[Snip]',
                    dictionary = '[Dict]',
                    omni = '[Omni]',
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

    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' },
        },
    })

    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline' },
        }),
    })
end

function M.cmp_dictionary()
    require('cmp_dictionary').setup({
        dic = {
            ['*'] = { g.root_dir .. '/dict/dictionary' },
            ['go'] = { g.root_dir .. '/dict/go.dict' },
            ['lua'] = { g.root_dir .. '/dict/xmake.dict' },
        },
        exact = 2,
        async = false,
        capacity = 5,
        debug = false,
    })
end

function M.lualine()
    local theme = 'auto'
    if vim.g.colors_name == 'solarized8' then
        theme = 'solarized'
    end

    require('lualine').setup({
        extensions = {},
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {},
        },
        options = {
            always_divide_middle = true,
            component_separators = {
                left = '|',
                right = '|',
            },
            disabled_filetypes = {},
            icons_enabled = false,
            section_separators = {
                left = '',
                right = '',
            },
            theme = theme,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
        tabline = {},
    })
end

function M.notify()
    require('notify').setup({
        -- fade_in_slide_out fade slide static
        stages = 'fade_in_slide_out',
        on_open = nil,
        on_close = nil,
        render = 'default',
        timeout = 5000,
        background_colour = 'Normal',
        minimum_width = 50,
        icons = {
            ERROR = 'E',
            WARN = 'W',
            INFO = 'I',
            DEBUG = 'D',
            TRACE = 'T',
        },
    })
    cmd([[
        highlight NotifyINFOIcon guifg=#009f9f
        highlight NotifyINFOTitle guifg=#009f9f
    ]])
    vim.notify = require('notify')
end

return M
