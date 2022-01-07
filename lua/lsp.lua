local M = {}
local config = {}

local bmap = require('remap').bmap
local g, cmd, fn, lsp = vim.g, vim.cmd, vim.fn, vim.lsp

local server = require('nvim-lsp-installer.server')
local std = require('nvim-lsp-installer.installers.std')
local lsp_installer = require('nvim-lsp-installer')
local path = require('nvim-lsp-installer.path')
local util = require('lspconfig/util')

local flags = { debounce_text_changes = 150 }

local on_attach = function(_, _)
    bmap('n', 'K', '<cmd>lua lsp.buf.hover()<CR>', {})
    bmap('n', '<C-k>', '<cmd>lua lsp.buf.signature_help()<CR>', {})
    bmap('n', '<space>rn', '<cmd>lua lsp.buf.rename()<CR>', {})
    bmap('n', '[d', '<cmd>lua lsp.diagnostic.goto_prev()<CR>', {})
    bmap('n', ']d', '<cmd>lua lsp.diagnostic.goto_next()<CR>', {})
end

local disalbe_diagnostics = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
})

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

function M.gofmt(timeout_ms)
    lsp.buf.formatting_sync(nil, timeout_ms)
end

function config.register_ccls()
    local ccls_root_dir = server.get_server_root_path('ccls')
    local ccls_server = server.Server:new({
        name = 'ccls',
        root_dir = ccls_root_dir,
        homepage = 'https://github.com/MaskRay/ccls',
        languages = { 'c', 'c++' },
        installer = {
            std.download_file(
                'https://github.com/fcying/tools/releases/download/tools/ccls_linux_amd64.zip',
                'ccls.zip'
            ),
            std.unzip('ccls.zip', '.'),
        },
        default_options = {
            cmd = { path.concat({ ccls_root_dir, 'ccls' }) },
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
        handlers = { ['textDocument/publishDiagnostics'] = disalbe_diagnostics },
        init_options = {
            compilationDatabaseDirectory = config_dir,
            cache = { directory = cache_dir },
        },
    }
end

function config.clangd()
    local clangd_cmd = { fn.expand(server.get_server_root_path('clangd') .. '/clangd_*/bin/clangd') }
    table.insert(clangd_cmd, '--background-index')
    if g.gencconf_storein_rootmarker == 1 then
        table.insert(clangd_cmd, '--compile-commands-dir=' .. g.root_marker)
    end
    M.server_opt.clangd = {
        on_attach = on_attach,
        flags = flags,
        handlers = { ['textDocument/publishDiagnostics'] = disalbe_diagnostics },
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
        root_dir = function(fname)
            return util.root_pattern('go.work')(fname)
                or util.root_pattern('go.mod', '.git', '.root')(fname)
                or util.path.dirname(fname)
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
                command! -nargs=0 Gofmt lua require('lsp').gofmt(200)
                autocmd FileType go autocmd BufWritePre <buffer> Goimports
            augroup END
        ]])
    end

    M.lspconfig()
end

return M
