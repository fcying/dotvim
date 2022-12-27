local M = {}
local config = {}

---@diagnostic disable-next-line unused-local
local map = require('remap').map
local bmap = require('remap').bmap
local g, cmd, fn, lsp = vim.g, vim.cmd, vim.fn, vim.lsp

local lspconfig = require('lspconfig')
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

---@diagnostic disable-next-line unused-local
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
    bmap(bufnr, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.format()<CR>', {})

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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = { 'utf-16' }

    M.server_opt.clangd = {
        on_attach = on_attach,
        flags = flags,
        cmd = clangd_cmd,
        capabilities = capabilities,
        --handlers = { ['textDocument/publishDiagnostics'] = diagnostics_config(0) },
    }
end

function config.go()
    M.server_opt.gopls = {
        on_attach = on_attach,
        flags = flags,
        settings = {
            gopls = {
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

function config.python()
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
    require('neodev').setup({
        library = {
            enabled = true,
            runtime = true,
            types = true,
            plugins = { 'plenary.nvim', 'telescope.nvim' },
        },
    })
    M.server_opt.sumneko_lua = {
        on_attach = on_attach,
        flags = flags,
        settings = {
            Lua = {
                IntelliSense = { traceLocalSet = true },
                workspace = {
                    library = {},
                    maxPreload = 10000,
                    checkThirdParty = false,
                },
                diagnostics = {
                    enable = true,
                    disable = { 'undefined-global', 'undefined-field', 'empty-block' },
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

    --setup lsp config
    M.server_opt = {
        ['default'] = {
            on_attach = on_attach,
            flags = flags,
        },
    }
    for _, c in pairs(config) do
        c()
    end

    require('mason').setup({
        install_root_dir = g.cache_dir .. '/mason',
        pip = {
            install_args = { '-i', 'https://opentuna.cn/pypi/web/simple' },
        },
    })

    local index = require('mason-registry.index')
    index['clangd'] = 'clangd'

    require('mason-lspconfig').setup({
        ensure_installed = {},
        automatic_installation = false,
    })

    require('mason-lspconfig').setup_handlers({
        function(server_name)
            if fn.index(g.lsp_ignore, server_name) == -1 then
                lspconfig[server_name].setup(M.server_opt[server_name] or M.server_opt['default'])
            end
        end,
    })
end

function M.setup()
    vim.cmd([[command! -nargs=0 Format lua vim.lsp.buf.format()]])
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
