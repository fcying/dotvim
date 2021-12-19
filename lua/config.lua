local M = {}

local map = require('remap').map
local bmap = require('remap').bmap
local g, cmd, fn, lsp, api = vim.g, vim.cmd, vim.fn, vim.lsp, vim.api

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
        compile_path  = g.plug_dir .. '/plugin/packer_compiled.lua',
        plugin_package = 'packer',
        auto_clean = false,
    })

    use({'wbthomason/packer.nvim', opt = true})
    for _, value in ipairs(g.plug_options) do
        local options = {value[1]}
        if (value[2] ~= "nil") then
            for k, v in pairs(value[2]) do
                options[k] = v
            end
            if (value[2]['run'] ~= nil) then
                local s = value[2]['run']
                if string.find(s, "^function") == nil then
                    options['run'] = s
                else
                    options['run'] = function() fn[string.match(s, "function%('(.-)'%)")](0) end
                end
            end
            if (value[2]['config'] ~= nil) then
                options['config'] = conf(value[2]['config'])
            end
        end
        options['opt'] = true
        use(options)
        --print(vim.inspect(options))
    end
end

function M.filetype()
    if fn.has('nvim-0.6') == 0 then
        g.did_load_filetypes = 1
    end

    require('filetype').setup({
        complex = {
            [".*git/config"] = "gitconfig",
        },
    })
end

function M.telescope_map()
    if (fn.HasPlug('LeaderF') == -1) then    --{{{
        map('n', 'fm', '<cmd>Telescope oldfiles<cr>', {})
        map('n', 'fb', '<cmd>Telescope buffers<cr>', {})
        map('n', 'fo', '<cmd>Telescope ctags_outline outline<cr>', {})
        map('n', 'fl', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {})
        map('n', 'fh', '<cmd>Telescope help_tags<cr>', {})
        map('n', 'ft', '<cmd>Telescope tags<cr>', {})
        map('n', 'fj', '<cmd>Telescope jumplist<cr>', {})
        map('n', 'fr', '<cmd>Telescope resume<cr>', {})
        map('n', 'f/', '<cmd>Telescope live_grep<cr>', {})
        map('n', 'fg', '<cmd>Telescope grep_string<cr>', {})
        cmd([[
            vnoremap fg :<C-u>lua require("telescope.builtin.files").grep_string({search="<C-R>=GetVisualSelection()<CR>"})
            nnoremap <silent>ff :<C-u><C-R>=g:find_command<CR><CR>
        ]])
    end

    map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', {})
    map('n', '<leader>lr', '<cmd>Telescope lsp_references<cr>', {})
    map('n', '<leader>lt', '<cmd>Telescope lsp_type_definitions<cr>', {})
    map('n', '<leader>li', '<cmd>Telescope lsp_implementations<cr>', {})
    map('n', '<leader>la', '<cmd>Telescope lsp_code_actions<cr>', {})
    map('n', '<leader>ls', '<cmd>Telescope lsp_document_symbols<cr>', {})
    map('n', '<leader>le', '<cmd>Telescope diagnostics bufnr=0<cr>', {})
    map('n', '<leader>lo', '<cmd>Telescope ctags_outline outline<cr>', {})
end
function M.telescope_update_ignore()
    g.find_command = 'Telescope find_files '
    if (g.has_rg == 1) then
        g.find_command = g.find_command .. 'find_command=rg,--files,--color=never'
        if (g.ignore_full.rg) then
            g.find_command = g.find_command .. ',' .. table.concat(g.ignore_full.rg,',')
        end
    end

    if _G["TelescopeGlobalState"] ~= nil then
        local conf = require('telescope.config').values
        conf.vimgrep_arguments = {'rg','--color=never','--with-filename','--line-number','--column','--smart-case'}
        for _,v in ipairs(g.ignore_full.rg) do
            table.insert(conf.vimgrep_arguments, v)
        end
    end
end
function M.telescope()
    local actions = require('telescope.actions')
    local toggle_modes = function()
        local mode = api.nvim_get_mode().mode
        if mode == "n" then
            cmd [[startinsert]]
            return
        elseif mode == "i" then
            cmd [[stopinsert]]
            return
        end
    end
    require('telescope').setup{
        defaults = {
            --horizontal vertical flex center
            layout_strategy='vertical',
            mappings = {
                i = {
                    ["<esc>"] = actions.close,
                    ["<c-j>"] = actions.move_selection_next,
                    ["<c-k>"] = actions.move_selection_previous,
                    ["<tab>"] = toggle_modes,
                    ["<c-s>"] = actions.toggle_selection,
                    ["<C-q>"] = actions.send_to_qflist,
                },
                n = {
                    ["<tab>"] = toggle_modes,
                    ["<c-s>"] = actions.toggle_selection,
                    ["<C-q>"] = actions.send_to_qflist,
                }
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            },
            ctags_outline = {
                ctags_opt = {'ctags'}
            }
        }
    }
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ctags_outline')
    M.telescope_update_ignore()
end

function M.lspconfig()
    --lsp.set_log_level('debug')

    local nvim_lsp = require('lspconfig')
    local util = require('lspconfig/util')

    cmd([[ autocmd myau FileType lspinfo nnoremap <silent><buffer> q :q<cr> ]])

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(_, _)
        --bmap('n', 'gD', '<cmd>lua lsp.buf.declaration()<CR>', {})
        --bmap('n', 'gd', '<cmd>lua lsp.buf.definition()<CR>', {})
        bmap('n', 'K', '<cmd>lua lsp.buf.hover()<CR>', {})
        --bmap('n', 'gi', '<cmd>lua lsp.buf.implementation()<CR>', {})
        bmap('n', '<C-k>', '<cmd>lua lsp.buf.signature_help()<CR>', {})
        --bmap('n', '<space>wa', '<cmd>lua lsp.buf.add_workspace_folder()<CR>', {})
        --bmap('n', '<space>wr', '<cmd>lua lsp.buf.remove_workspace_folder()<CR>', {})
        --bmap('n', '<space>wl', '<cmd>lua print(vim.inspect(lsp.buf.list_workspace_folders()))<CR>', {})
        --bmap('n', '<space>D', '<cmd>lua lsp.buf.type_definition()<CR>', {})
        bmap('n', '<space>rn', '<cmd>lua lsp.buf.rename()<CR>', {})
        bmap('n', '<space>ca', '<cmd>lua lsp.buf.code_action()<CR>', {})
        --bmap('n', 'gr', '<cmd>lua lsp.buf.references()<CR>', {})
        bmap('n', '<space>e', '<cmd>lua lsp.diagnostic.show_line_diagnostics()<CR>', {})
        bmap('n', '[d', '<cmd>lua lsp.diagnostic.goto_prev()<CR>', {})
        bmap('n', ']d', '<cmd>lua lsp.diagnostic.goto_next()<CR>', {})
        --bmap('n', '<space>q', '<cmd>lua lsp.diagnostic.set_loclist()<CR>', {})
        --bmap('n', '<space>f', '<cmd>lua lsp.buf.formatting()<CR>', {})
    end

    local use_lsp_installer = 0
    local lsp_installer, server, path, std
    if (fn.HasPlug('nvim-lsp-installer') ~= -1) then
        use_lsp_installer = 1
        lsp_installer = require'nvim-lsp-installer'
        server = require "nvim-lsp-installer.server"
        path = require "nvim-lsp-installer.path"
        std = require "nvim-lsp-installer.installers.std"

        lsp_installer.settings {
            install_root_dir = path.concat { g.cache_dir, "lsp_servers" },
        }

        --register ccls
        local root_dir = server.get_server_root_path('ccls')
        local ccls_server = server.Server:new {
            name = 'ccls',
            root_dir = root_dir,
            homepage = "https://github.com/MaskRay/ccls",
            languages = { "c", "c++" },
            installer = {
                std.download_file("https://github.com/fcying/tools/releases/download/tools/ccls_linux_amd64.zip", "ccls.zip"),
                std.unzip('ccls.zip', '.'),
            },
            default_options = {
                cmd = { path.concat { root_dir, 'ccls' } }
            },
        }
        lsp_installer.register(ccls_server)
    end

    local disalbe_diagnostics = lsp.with(
    lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = false,
        signs = false,
        update_in_insert = false,
    })

    --lsp gopls lua default config {{{
    local server_opts = {
        ['gopls'] = {
            on_attach = on_attach;
            flags = { debounce_text_changes = 150 };
            root_dir = function(fname)
                return util.root_pattern 'go.work'(fname) or
                util.root_pattern('go.mod', '.git', '.root')(fname) or util.path.dirname(fname)
            end;
        },
        ['sumneko_lua'] = require('lua-dev').setup({
            library = {
                vimruntime = true,
                types = true,
                plugins = true,
            },
            lspconfig = {
                on_attach = on_attach;
                flags = { debounce_text_changes = 150 };
            }}),
        ['default'] = {
            on_attach = on_attach;
            flags = { debounce_text_changes = 150 };
        },
    }

    --lsp ccls config {{{
    local cache_dir = ".ccls-cache"
    local config_dir = ""
    if g.gencconf_storein_rootmarker == 1 then
        config_dir = g.root_marker
        cache_dir = g.root_marker .. "/.ccls-cache"
    end
    server_opts.ccls = {
        on_attach = on_attach;
        flags = { debounce_text_changes = 150 };
        handlers = { ["textDocument/publishDiagnostics"] = disalbe_diagnostics };
        init_options = {
            compilationDatabaseDirectory = config_dir;
            cache = { directory = cache_dir };
        };
    }

    --lsp clangd config {{{
    local clangd_cmd = {}
    if (use_lsp_installer == 1) then
        clangd_cmd = { fn.expand(server.get_server_root_path('clangd') .. '/clangd_*/bin/clangd') }
    else
        clangd_cmd = { "clangd" }
    end
    table.insert(clangd_cmd, "--background-index")
    if g.gencconf_storein_rootmarker == 1 then
        table.insert(clangd_cmd, "--compile-commands-dir=" .. g.root_marker)
    end
    server_opts.clangd = {
        on_attach = on_attach;
        flags = { debounce_text_changes = 150 };
        handlers = { ["textDocument/publishDiagnostics"] = disalbe_diagnostics };
        cmd = clangd_cmd;
    }

    --server setup
    if (use_lsp_installer == 1) then
        lsp_installer.on_server_ready(function(s)
            if fn.index(g.lsp_servers, s.name) ~= -1 then
                s:setup(server_opts[s.name] or server_opts['default'])
            end
        end)
    else
        for _, name in ipairs(g.lsp_servers) do
            nvim_lsp[name].setup(server_opts[name] or server_opts['default'])
        end
    end
end

function M.cmp()
    cmd([[autocmd myau BufEnter * setl omnifunc=syntaxcomplete#Complete]])
    local cmp = require'cmp'
    cmp.setup({
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
                fn["vsnip#anonymous"](args.body)
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
            { name = 'buffer' }
        }
    })

    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline' },
        })
    })

    require('config').cmp_dictionary()
end

function M.cmp_dictionary()
    require("cmp_dictionary").setup({
        dic = {
            ['*'] = {g.root_dir .. '/dict/dictionary'},
            ['go'] = {g.root_dir .. '/dict/go.dict'},
        },
        exact = 2,
        async = false,
        capacity = 5,
        debug = false,
    })
end

return M
