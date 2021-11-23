local map = vim.api.nvim_set_keymap
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

if (vim.fn.HasPlug('filetype.nvim') ~= -1) then    --{{{
    if vim.fn.has('nvim-0.6') == 0 then
        vim.g.did_load_filetypes = 1
    end

    require('filetype').setup({
        complex = {
            [".*git/config"] = "gitconfig",
        },
    })
end

if (vim.fn.HasPlug('telescope.nvim') ~= -1) then    --{{{
    map('n', 'fm', '<cmd>Telescope oldfiles<cr>', { noremap = true })
    map('n', 'fb', '<cmd>Telescope buffers<cr>', { noremap = true })
    map('n', 'fo', '<cmd>Telescope lsp_document_symbols<cr>', { noremap = true })
    map('n', 'fl', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { noremap = true })
    map('n', 'fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
    map('n', 'ft', '<cmd>Telescope tags<cr>', { noremap = true })
    map('n', 'f/', '<cmd>Telescope live_grep<cr>', { noremap = true })
    map('n', 'fg', '<cmd>Telescope grep_string<cr>', { noremap = true })
    map('n', 'fj', '<cmd>Telescope jumplist<cr>', { noremap = true })
    map('n', 'fr', '<cmd>Telescope resume<cr>', { noremap = true })

    local find_command = ''
    if (vim.g.has_rg == 1) then
        find_command = 'find_command=rg,--ignore,--hidden,--files'
        if (vim.g.ignore_full.rg) then
            find_command = find_command .. ',' .. table.concat(vim.g.ignore_full.rg,',')
        end
    end
    map('n', 'ff', '<cmd>Telescope find_files ' .. find_command .. '<cr>', { noremap = true })

    local actions = require('telescope.actions')
    local toggle_modes = function()
        local mode = vim.api.nvim_get_mode().mode
        if mode == "n" then
            vim.cmd [[startinsert]]
            return
        elseif mode == "i" then
            vim.cmd [[stopinsert]]
            return
        end
    end
    require('telescope').setup{
        defaults = {
            layout_strategy='vertical',
            mappings = {
                i = {
                    ["<esc>"] = actions.close,
                    ["<c-j>"] = actions.move_selection_next,
                    ["<c-k>"] = actions.move_selection_previous,
                    ["<tab>"] = toggle_modes,
                    ["<c-s>"] = actions.toggle_selection,
                },
                n = {
                    ["<tab>"] = toggle_modes,
                    ["<c-s>"] = actions.toggle_selection,
                }
            },
        }
    }
end

if (vim.fn.HasPlug('nvim-lspconfig') ~= -1) then    --{{{
    --vim.lsp.set_log_level('debug')

    local nvim_lsp = require('lspconfig')
    local util = require('lspconfig/util')

    vim.cmd([[ autocmd myau FileType lspinfo nnoremap <silent><buffer> q :q<cr> ]])

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        --buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end

    local use_lsp_installer = 0
    local lsp_installer, server, path, platform, std
    if (vim.fn.HasPlug('nvim-lsp-installer') ~= -1) then
        use_lsp_installer = 1
        lsp_installer = require'nvim-lsp-installer'
        server = require "nvim-lsp-installer.server"
        path = require "nvim-lsp-installer.path"
        platform = require "nvim-lsp-installer.platform"
        std = require "nvim-lsp-installer.installers.std"

        lsp_installer.settings {
            install_root_dir = path.concat { vim.g.cache_dir, "lsp_servers" },
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

    local disalbe_diagnostics = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = false,
        signs = false,
        update_in_insert = false,
    })

    local server_opts = {
        ['gopls'] = {
            on_attach = on_attach;
            flags = { debounce_text_changes = 150 };
            root_dir = function(fname)
                return util.root_pattern 'go.work'(fname) or util.root_pattern('go.mod', '.git', '.root')(fname) or util.path.dirname(fname)
            end;
        },
        ['default'] = {
            on_attach = on_attach;
            flags = { debounce_text_changes = 150 };
        },
    }

    --ccls config
    local cache_dir = ".ccls-cache"
    local config_dir = ""
    if vim.g.gencconf_storein_rootmarker == 1 then
        config_dir = vim.g.root_marker
        cache_dir = vim.g.root_marker .. "/.ccls-cache"
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

    --clangd config
    if (use_lsp_installer == 1) then
        clangd_cmd = { vim.fn.expand(server.get_server_root_path('clangd') .. '/clangd_*/bin/clangd') }
    else
        clangd_cmd = { "clangd" }
    end
    table.insert(clangd_cmd, "--background-index")
    if vim.g.gencconf_storein_rootmarker == 1 then
        table.insert(clangd_cmd, "--compile-commands-dir=" .. vim.g.root_marker)
    end
    server_opts.clangd = {
        on_attach = on_attach;
        flags = { debounce_text_changes = 150 };
        handlers = { ["textDocument/publishDiagnostics"] = disalbe_diagnostics };
        cmd = clangd_cmd;
    }

    --server setup
    if (use_lsp_installer == 1) then
        lsp_installer.on_server_ready(function(server)
            if vim.fn.index(vim.g.lsp_servers, server.name) ~= -1 then
                server:setup(server_opts[server.name] or server_opts['default'])
            end
        end)
    else
        for _, lsp in ipairs(vim.g.lsp_servers) do
            nvim_lsp[lsp].setup(server_opts[lsp] or server_opts['default'])
        end
    end
end

if (vim.fn.HasPlug('nvim-cmp') ~= -1) then    --{{{
    local cmp = require'cmp'
    cmp.setup({
        mapping = {
            ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        },
        sources = {
            { name = 'vsnip' },
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            --{
            --    name = 'tmux',
            --    opts = {
            --        all_panes = false,
            --        trigger_characters = { '.' },
            --        trigger_characters_ft = {}
            --    }
            --},
            { name = 'tags' },
            { name = 'path' },
            { name = 'buffer' },
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = ({
                    buffer = '[Buf]',
                    nvim_lsp = '[Lsp]',
                    nvim_lua = '[Lua]',
                    tags = '[Tag]',
                    tmux = '[Tmux]',
                    vsnip = '[Snip]',
                })[entry.source.name]
                return vim_item
            end,
        },
    })
end
