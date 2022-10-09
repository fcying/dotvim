local M = {}
local config = {}

--local map = require('remap').map
local bmap = require('remap').bmap
local g, cmd, fn, lsp = vim.g, vim.cmd, vim.fn, vim.lsp

local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

local lsp_installer = require('nvim-lsp-installer')
local server = require('nvim-lsp-installer.server')
local servers = require('nvim-lsp-installer.servers')
local std = require('nvim-lsp-installer.core.managers.std')
local path = require('nvim-lsp-installer.core.path')
local github = require('nvim-lsp-installer.core.managers.github')
local process = require('nvim-lsp-installer.core.process')
local platform = require('nvim-lsp-installer.core.platform')
local functional = require('nvim-lsp-installer.core.functional')

local flags = { debounce_text_changes = 150 }

local diagnostics_on = true
function M.diagnostic_toggle()
    if diagnostics_on then
        vim.notify('disable diagnostics')
        vim.diagnostic.disable()
    else
        vim.notify('enable diagnostics')
        vim.diagnostic.enable()
    end
    diagnostics_on = not diagnostics_on
end

local function diagnostics_config(enable)
    if enable == nil then
        enable = 1
    end

    if enable == 0 then
        return lsp.with(lsp.diagnostic.on_publish_diagnostics, {
            underline = false,
            virtual_text = false,
            signs = false,
            update_in_insert = false,
        })
    end
end

---@diagnostic disable-next-line unused-local
local on_attach = function(client, bufnr)
    bmap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
    bmap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {})
    bmap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
    bmap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {})
    bmap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', {})
    bmap(bufnr, 'n', '<leader>ld', '<cmd>lua require("lsp").diagnostic_toggle()<CR>', {})
    bmap(bufnr, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {})

    vim.api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                border = 'none',
                source = 'always', -- show source in diagnostic popup window
                prefix = ' ',
            }

            if diagnostics_on then
                if not vim.b.diagnostics_pos then
                    vim.b.diagnostics_pos = { nil, nil }
                end

                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                if
                    (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
                    and #vim.diagnostic.get() > 0
                then
                    vim.diagnostic.open_float(nil, opts)
                end

                vim.b.diagnostics_pos = cursor_pos
            end
        end,
    })
end

-- https://github.com/golang/tools/tree/master/gopls
-- fork from https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
function M.goimports(timeout_ms)
    if vim.fn.get(servers.get_installed_server_names(), 'gopls') ~= 1 then
        return
    end

    local context = { only = { 'source.organizeImports' } }
    vim.validate({ context = { context, 't', true } })

    local params = lsp.util.make_range_params()
    params.context = context

    local clients = vim.lsp.buf_get_clients(0)
    local client = clients[next(clients)] or { offset_encoding = 'utf-8' }
    local result = lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
            else
                lsp.buf.execute_command(r.command)
            end
        end
    end

    lsp.buf.formatting_sync(nil, timeout_ms)
end

function config.register_ccls()
    local root_dir = server.get_server_root_path('ccls')

    local ccls_server = server.Server:new({
        name = 'ccls',
        root_dir = root_dir,
        homepage = 'https://github.com/MaskRay/ccls',
        languages = { 'c', 'c++', 'objective-c' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'h', 'hh' },
        async = true,
        installer = function(ctx)
            if platform.is_linux == true then
                ctx.github_release_file = 'https://github.com/fcying/tools/releases/download/tools/ccls_linux_amd64.txz'
                std.download_file(ctx.github_release_file, 'ccls.txz')
                std.untarxz('ccls.txz')
            elseif platform.is_win == true then
                ctx.github_release_file =
                    'https://github.com/fcying/tools/releases/download/tools/ccls_windows_amd64.zip'
                std.download_file(ctx.github_release_file, 'ccls.zip')
                std.unzip('ccls.zip')
            else
                print('unsupport platform')
            end
        end,
        default_options = {
            cmd_env = {
                PATH = process.extend_path({ root_dir }),
            },
        },
    })
    lsp_installer.register(ccls_server)
end

function config.ccls()
    local cache_dir = '.ccls-cache'
    local config_dir = ''
    if g.gencconf_storein_rootmarker == 1 then
        config_dir = g.root_marker
        cache_dir = g.root_marker .. '/.ccls-cache'
    end
    M.server_opt.ccls = {
        on_attach = on_attach,
        flags = flags,
        handlers = { ['textDocument/publishDiagnostics'] = diagnostics_config(0) },
        init_options = {
            compilationDatabaseDirectory = config_dir,
            cache = { directory = cache_dir },
            clang = {
                excludeArgs = {},
                extraArgs = { '-Wno-implicit-function-declaration' },
            },
        },
    }
end

function config.register_clangd()
    local root_dir = server.get_server_root_path('clangd')
    local coalesce, when = functional.coalesce, functional.when

    local clangd_server = server.Server:new({
        name = 'clangd',
        root_dir = root_dir,
        homepage = 'https://clangd.llvm.org',
        languages = { 'c', 'c++' },
        async = true,
        installer = function(ctx) ---@diagnostic disable-line unused-local
            local source
            if platform.is_linux == true then
                source = github.untarxz_release_file({
                    repo = 'fcying/tools',
                    release = 'tools',
                    asset_file = 'clangd_linux_amd64.txz',
                })
            else
                source = github.unzip_release_file({
                    repo = 'clangd/clangd',
                    asset_file = function(release)
                        local target = coalesce(
                            when(platform.is_mac, 'clangd-mac-%s.zip'),
                            when(platform.is_linux and platform.arch == 'x64', 'clangd-linux-%s.zip'),
                            when(platform.is_win, 'clangd-windows-%s.zip')
                        )
                        return target and target:format(release)
                    end,
                })
            end
            source.with_receipt()
            --ctx.fs:rename(("clangd_%s"):format(source.release), "clangd")
        end,
        default_options = {
            cmd_env = {
                PATH = process.extend_path({ path.concat({ fn.expand(root_dir .. '/clangd*'), 'bin' }) }),
            },
        },
    })
    lsp_installer.register(clangd_server)
end

function config.clangd()
    local clangd_cmd = { 'clangd' }
    table.insert(clangd_cmd, '--background-index')
    table.insert(clangd_cmd, '--all-scopes-completion')
    table.insert(clangd_cmd, '--completion-style=detailed')
    table.insert(clangd_cmd, '--header-insertion=iwyu')
    table.insert(clangd_cmd, '--pch-storage=memory')
    if g.gencconf_storein_rootmarker == 1 then
        table.insert(clangd_cmd, '--compile-commands-dir=' .. g.root_marker)
    end

    cmd([[ autocmd myau FileType c,cpp nnoremap <silent> <buffer> <Leader>h <ESC>:ClangdSwitchSourceHeader<CR> ]])

    M.server_opt.clangd = vim.tbl_deep_extend('force', M.server_opt.default, {
        cmd = clangd_cmd,
        --handlers = { ['textDocument/publishDiagnostics'] = diagnostics_config(0) },
    })
end

function config.go()
    M.server_opt.gopls = vim.tbl_deep_extend('force', M.server_opt.default, {
        settings = {
            gopls = {
                experimentalWorkspaceModule = true,
                analyses = {
                    unusedparams = false,
                },
            },
        },
        single_file_support = true,
        root_dir = function(fname)
            return util.root_pattern('go.work')(fname) or util.root_pattern('go.mod', '.root', '.git')(fname)
        end,
    })
    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.go' },
        callback = function()
            M.goimports(500)
        end,
    })
end

function config.pylsp()
    M.server_opt.pylsp = vim.tbl_deep_extend('force', M.server_opt.default, {
        settings = {
            pylsp = {
                plugins = {
                    jedi = {
                        environment = g.pylsp_jedi_environment or fn.exepath('python3'),
                    },
                    pycodestyle = {
                        maxLineLength = 120,
                        ignore = { 'E302', 'E265', 'E231' },
                    },
                },
            },
        },
    })
end

function config.lua()
    require('neodev').setup({
        library = {
            enabled = true,
            runtime = true,
            types = true,
            plugins = { 'plenary.nvim', 'telescope.nvim' },
        },
    })
    M.server_opt.sumneko_lua = {
        settings = {
            Lua = {
                IntelliSense = { traceLocalSet = true },
                workspace = {
                    library = {},
                    maxPreload = 10000,
                },
                diagnostics = {
                    enable = true,
                    disable = { 'undefined-global', 'empty-block' },
                    --neededFileStatus = {
                    --    ['codestyle-check'] = 'Any',
                    --},
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = 'space',
                        indent_size = '4',
                        quote_style = 'single',
                        call_arg_parentheses = 'keep',
                        align_function_define_params = 'true',
                        keep_one_space_between_table_and_bracket = 'true',
                    },
                },
            },
        },
    }
end

function M.lspconfig()
    --lsp.set_log_level('debug')

    cmd([[ autocmd myau FileType lspinfo nnoremap <silent><buffer> q :q<cr> ]])

    lsp_installer.setup({})

    lsp_installer.settings({
        install_root_dir = path.concat({ g.cache_dir, 'lsp_servers' }),
    })

    M.server_opt = {
        ['default'] = {
            on_attach = on_attach,
            flags = flags,
        },
    }
    for _, v in pairs(config) do
        v()
    end

    --print(vim.inspect(M.server_opt.clangd))
    --server setup
    for _, s in ipairs(lsp_installer.get_installed_servers()) do
        if fn.index(g.lsp_ignore, s.name) == -1 then
            lspconfig[s.name].setup(M.server_opt[s.name] or M.server_opt['default'])
        end
    end
end

function M.setup()
    vim.cmd([[command! -nargs=0 Format lua vim.lsp.buf.formatting_sync(nil, 500)]])
    M.lspconfig()
    vim.diagnostic.config({
        virtual_text = false,
        float = {
            show_header = true,
            source = 'always',
            focusable = false,
            format = function(diagnostic)
                --vim.notify(vim.inspect(diagnostic))
                return string.format('%s\n[%s]', diagnostic.message, diagnostic.user_data.lsp.code)
            end,
        },
    })
end

return M
