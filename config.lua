local cmd = vim.cmd
local fn = vim.fn

if (vim.fn.HasPlug('filetype.nvim') ~= -1) then    --{{{
    vim.g.did_load_filetypes = 1
end

if (vim.fn.HasPlug('telescope.nvim') ~= -1) then    --{{{
    vim.api.nvim_set_keymap('n', 'ff', '<cmd>Telescope find_files<cr>', { noremap = true })
    vim.api.nvim_set_keymap('n', 'ft', '<cmd>Telescope tags<cr>', { noremap = true })
    vim.api.nvim_set_keymap('n', 'fb', '<cmd>Telescope buffers<cr>', { noremap = true })
    vim.api.nvim_set_keymap('n', 'fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
    vim.api.nvim_set_keymap('n', 'f/', '<cmd>Telescope live_grep<cr>', { noremap = true })
    vim.api.nvim_set_keymap('n', 'fg', '<cmd>Telescope grep_string<cr>', { noremap = true })

    local actions = require('telescope.actions')
    require('telescope').setup{
        defaults = {
            mappings = {
                i = {
                    --["<esc>"] = actions.close
                },
                n = {
                    ["q"] = actions.close
                },
            },
        }
    }
end

if (vim.fn.HasPlug('nvim-lspconfig') ~= -1) then    --{{{
    --vim.lsp.set_log_level('debug')

    local nvim_lsp = require('lspconfig')
    local util = require('lspconfig/util')

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

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
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
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

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { 'pyright', 'vimls' }
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach;
            flags = { debounce_text_changes = 150 }
        }
    end

    nvim_lsp.gopls.setup {
        root_dir = function(fname)
            return util.root_pattern 'go.work'(fname) or util.root_pattern('go.mod', '.git', '.root')(fname) or util.path.dirname(fname)
        end,
        on_attach = on_attach;
        flags = { debounce_text_changes = 150 };
    }

    if vim.g.has_ccls == 1 then
        local cache_dir = ".ccls-cache"
        local config_dir = ""
        if vim.g.gencconf_storein_rootmarker == 1 then
            config_dir = vim.g.root_marker
            cache_dir = vim.g.root_marker .. "/.ccls-cache"
        end
        nvim_lsp.ccls.setup {
            on_attach = on_attach;
            init_options = {
                compilationDatabaseDirectory = config_dir;
                cache = { directory = cache_dir };
            };
            flags = { debounce_text_changes = 150 };
            handlers = {
                ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    underline = false,
                    virtual_text = false,
                    signs = false,
                    update_in_insert = false,
                }
                ),
            };
        }
    else
        local clangd_cmd = { "clangd", "--background-index" }
        if vim.g.gencconf_storein_rootmarker == 1 then
            table.insert(clangd_cmd, "--compile-commands-dir=" .. vim.g.root_marker)
        end
        nvim_lsp.clangd.setup {
            cmd = clangd_cmd;
            on_attach = on_attach;
            flags = { debounce_text_changes = 150 };
            handlers = {
                ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    underline = false,
                    virtual_text = false,
                    signs = false,
                    update_in_insert = false,
                }
                ),
            };
        }
    end
end

if (vim.fn.HasPlug('nvim-cmp') ~= -1) then    --{{{
    local cmp = require'cmp'
    cmp.setup({
        mapping = {
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
            { name = 'vsnip' },
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            {
                name = 'tmux',
                opts = {
                    all_panes = false,
                    trigger_characters = { '.' },
                    trigger_characters_ft = {}
                }
            },
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
