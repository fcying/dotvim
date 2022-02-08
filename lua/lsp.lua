local M = {}
local config = {}

--local map = require('remap').map
local bmap = require('remap').bmap
local g, cmd, fn, lsp = vim.g, vim.cmd, vim.fn, vim.lsp

local server = require('nvim-lsp-installer.server')
local std = require('nvim-lsp-installer.installers.std')
local lsp_installer = require('nvim-lsp-installer')
local path = require('nvim-lsp-installer.path')
local util = require('lspconfig/util')

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

local on_attach = function(_, _)
    bmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
    bmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {})
    bmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
    bmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {})
    bmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', {})
    bmap('n', '<leader>ld', '<cmd>lua require("lsp").diagnostic_toggle()<CR>', {})
    bmap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {})
end

-- https://github.com/golang/tools/tree/master/gopls
-- fork from https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
function M.goimports(timeout_ms)
    local server_available, _ = lsp_installer.get_server('gopls')
    if server_available == false then
        return
    end

    local context = { only = { 'source.organizeImports' } }
    vim.validate({ context = { context, 't', true } })

    local params = lsp.util.make_range_params()
    params.context = context

    local result = lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                lsp.util.apply_workspace_edit(r.edit)
            else
                lsp.buf.execute_command(r.command)
            end
        end
    end

    lsp.buf.formatting_sync(nil, timeout_ms)
end

function config.register_ccls()
    local platform = require('nvim-lsp-installer.platform')
    local context = require('nvim-lsp-installer.installers.context')
    local process = require('nvim-lsp-installer.process')
    local root_dir = server.get_server_root_path('ccls')
    local ccls_server = server.Server:new({
        name = 'ccls',
        root_dir = root_dir,
        homepage = 'https://github.com/MaskRay/ccls',
        languages = { 'c', 'c++', 'objective-c' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'h', 'hh' },
        installer = {
            context.capture(function()
                if platform.is_linux == true then
                    return std.untarxz_remote(
                        'https://github.com/fcying/tools/releases/download/tools/ccls_linux_amd64.txz'
                    )
                elseif platform.is_win == true then
                    return std.unzip_remote(
                        'https://github.com/fcying/tools/releases/download/tools/ccls_windows_amd64.zip'
                    )
                end
                print('unsupport platform')
            end),
        },
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
    local platform = require('nvim-lsp-installer.platform')
    local context = require('nvim-lsp-installer.installers.context')
    local process = require('nvim-lsp-installer.process')
    local Data = require('nvim-lsp-installer.data')
    local root_dir = server.get_server_root_path('clangd')
    local clangd_server = server.Server:new({
        name = 'clangd',
        root_dir = root_dir,
        homepage = 'https://clangd.llvm.org',
        languages = { 'c', 'c++' },
        installer = {
            context.use_github_release_file('clangd/clangd', function(version)
                local target_file = Data.coalesce(
                    Data.when(platform.is_mac, 'clangd-mac-%s.zip'),
                    Data.when(platform.is_linux and platform.arch == 'x64', 'clangd-linux-%s.zip'),
                    Data.when(platform.is_win, 'clangd-windows-%s.zip')
                )
                return target_file and target_file:format(version)
            end),
            context.capture(function(ctx)
                if platform.is_linux == true then
                    ctx.github_release_file =
                        'https://github.com/fcying/tools/releases/download/tools/clangd_linux_amd64.txz'
                    return std.untarxz_remote(ctx.github_release_file)
                else
                    return std.unzip_remote(ctx.github_release_file)
                end
            end),
            context.receipt(function(receipt, ctx)
                receipt:with_primary_source(receipt.github_release_file(ctx))
            end),
        },
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

    M.server_opt.clangd = {
        on_attach = on_attach,
        flags = flags,
        --handlers = { ['textDocument/publishDiagnostics'] = diagnostics_config(0) },
        cmd = clangd_cmd,
    }
end

function config.go()
    M.server_opt.gopls = {
        on_attach = on_attach,
        flags = flags,
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
    }
end

function config.pylsp()
    M.server_opt.pylsp = {
        on_attach = on_attach,
        flags = flags,
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
    }
end

function config.lua()
    M.server_opt.sumneko_lua = require('lua-dev').setup({
        library = {
            vimruntime = true,
            types = true,
            plugins = true,
        },
        runtime_path = false, -- enable this to get completion in require strings. Slow!
        lspconfig = {
            on_attach = on_attach,
            flags = flags,
            settings = {
                Lua = {
                    IntelliSense = {
                        traceLocalSet = true,
                    },
                    workspace = {
                        library = {},
                        maxPreload = 10000,
                    },
                    diagnostics = {
                        enable = true,
                        disable = { 'undefined-global', 'empty-block' },
                    },
                },
            },
        },
    })
end

function M.lspconfig()
    --lsp.set_log_level('debug')

    cmd([[ autocmd myau FileType lspinfo nnoremap <silent><buffer> q :q<cr> ]])

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

    --server setup
    lsp_installer.on_server_ready(function(s)
        if fn.index(g.lsp_ignore, s.name) ~= -1 then
            return
        end
        s:setup(M.server_opt[s.name] or M.server_opt['default'])
    end)
end

function M.setup()
    if vim.g.has_go == 1 then
        vim.cmd([[
            augroup go_lang
                autocmd!
                autocmd! * <buffer>
                command! -nargs=0 Goimports lua require('lsp').goimports(800)
                autocmd FileType go autocmd BufWritePre <buffer> Goimports
            augroup END
        ]])
    end

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
