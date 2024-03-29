local g, cmd, fn, lsp, api = vim.g, vim.cmd, vim.fn, vim.lsp, vim.api
local util = require("util")
local map = util.map
local M = {}
local lsp_opts = {}

local formats = {
    stylua = {
        "--indent-type", "Spaces",
        "--indent-width", "4",
        "--quote-style", "AutoPreferDouble", -- AutoPreferDouble, AutoPreferSingle, ForceDouble, ForceSingle
    },
    astyle = {
        "-A1", "-s4", "-S", "-N",
        "-L", "-w", "-m0", "-M100",
        "-p", "-H", "-k3", "-W3",
        "-c", "-n", "-j", "-xC120",
        "--lineend=linux",
    },
}

local diagnostics_on = true
function M.diagnostic_toggle()
    if diagnostics_on then
        vim.notify("disable diagnostics")
        vim.diagnostic.disable()
    else
        vim.notify("enable diagnostics")
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

function M.guard()
    return {
        "nvimdev/guard.nvim",
        cmd = "GuardFmt", -- broken auto format
        config = function()
            local ft = require("guard.filetype")
            ft("c"):fmt({
                cmd = "astyle",
                args = formats.astyle,
            })
            ft("cpp"):fmt({
                cmd = "astyle",
                args = formats.astyle,
            })

            require("guard").setup({
                fmt_on_save = false,
            })
        end
    }
end

function M.format()
    local custom_format = { "c", "cpp" }
    if vim.fn.index(custom_format, vim.o.filetype) ~= -1 then
        vim.cmd("GuardFmt")
    else
        vim.lsp.buf.format()
    end
end

function M.null_ls()
    local nls = require("null-ls")
    local formatting = nls.builtins.formatting
    ---@diagnostic disable-next-line unused-local
    local diagnostics = nls.builtins.diagnostics

    return {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            debug = false,
            root_dir = require("null-ls.utils").root_pattern(".root", ".neoconf.json", ".git"),
            sources = {
                formatting.gofmt,
                formatting.goimports,
                --formatting.clang_format,
                formatting.astyle.with({ extra_args = formats.astyle }),
                --formatting.stylua.with({ extra_args = formats.stylua }),
            },
        }
    }
end

function lsp_opts.qmlls()
    local lsp_zero = require("lsp-zero")
    local lsp_util = require("lspconfig/util")
    local opts = {
        cmd = { "qmlls", "--build-dir", util.root_dir .. "/build" },
        filetypes = { "qml" },
        root_dir = function(fname)
            return lsp_util.find_git_ancestor(fname)
        end,
    }
    lsp_zero.configure("qmlls", opts)
end

function lsp_opts.clangd()
    local lsp_zero = require("lsp-zero")
    local clangd_cmd = { "clangd" }
    table.insert(clangd_cmd, "--background-index")
    table.insert(clangd_cmd, "--all-scopes-completion")
    table.insert(clangd_cmd, "--completion-style=detailed")
    table.insert(clangd_cmd, "--header-insertion=iwyu")
    table.insert(clangd_cmd, "--pch-storage=memory")
    if g.clangd_query_driver then
        table.insert(clangd_cmd, "--query-driver=" .. g.clangd_query_driver)
    end
    if g.gencconf_storein_rootmarker == 1 then
        table.insert(clangd_cmd, "--compile-commands-dir=" .. util.root_marker)
    end

    cmd([[ autocmd myau FileType c,cpp nnoremap <silent> <buffer> <Leader>h <ESC>:ClangdSwitchSourceHeader<CR> ]])

    local opts = {
        cmd = clangd_cmd,
        --handlers = { ['textDocument/publishDiagnostics'] = diagnostics_config(0) },
    }
    lsp_zero.configure("clangd", opts)
end

function lsp_opts.ahk2()
    local lsp_zero = require("lsp-zero")
    local path = require("mason-core.path").package_prefix("autohotkey2-lsp")
    local InterpreterPath = "AutoHotkey64.exe"
    if fn.has("linux") == 1 then
        InterpreterPath = fn.expand("$HOME/bin/") .. InterpreterPath
    end
    local opts = {
        cmd = { "node", path .. "/autohotkey2-lsp/server/dist/server.js", "--stdio" },
        filetypes = { "ahk", "autohotkey", "ah2" },
        init_options = {
            locale = "en-us",
            InterpreterPath = InterpreterPath,
        },
        root_dir = function()
            return util.root_dir
        end,
    }
    require("lspconfig.configs")["ahk2"] = { default_config = opts }
    lsp_zero.configure("ahk2")
end

function lsp_opts.bashls()
    local lsp_zero = require("lsp-zero")
    local opts = {
        filetypes = { "sh", "zsh" },
        settings = {
            bashIde = {
                shellcheckArguments = "-e SC1090,SC1091,SC2010,SC2012,SC2015,SC2046,SC2086,"
                    .. "SC2119,SC2120,SC2154,SC2155,SC2164,SC2181,SC2206,SC2317",
            }
        }
    }
    lsp_zero.configure("bashls", opts)
end

function lsp_opts.gopls()
    local lsp_zero = require("lsp-zero")
    local lsp_util = require("lspconfig/util")
    local opts = {
        settings = {
            gopls = {
                semanticTokens = true,
                analyses = {
                    unusedparams = false,
                },
            }
        },
        root_dir = function(fname)
            return lsp_util.root_pattern("go.work", "go.mod", ".root", ".git")(fname)
        end,
    }
    lsp_zero.configure("gopls", opts)
end

function lsp_opts.python()
    local lsp_zero = require("lsp-zero")
    local opts = {
        settings = {
            pylsp = {
                plugins = {
                    jedi = {
                        environment = g.pylsp_jedi_environment or fn.exepath("python3"),
                    },
                    pycodestyle = {
                        maxLineLength = 120,
                        ignore = { "E302", "E265", "E231" },
                    },
                },
            },
        },
    }
    lsp_zero.configure("pylsp", opts)
end

function lsp_opts.lua()
    local lsp_zero = require("lsp-zero")
    require("neodev").setup({
        override = function(_, options)
            if vim.loop.fs_stat(util.root_dir .. "/lua")
                or vim.fn.expand("%:t") == ".nvim.lua" then
                options.enabled = true
                options.plugins = {
                    "plenary.nvim",
                    "telescope.nvim",
                    "mason.nvim",
                    --"nvim-treesitter",
                }
            end
            --options.enabled = true
            --options.plugins = true
        end,
    })

    -- :lua vim.notify(vim.inspect(vim.lsp.get_active_clients({ name = "lua_ls" })[1].config.settings.Lua))
    local opts = {
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                    library = { g.config_dir .. "/lua" },
                },
                completion = {
                    callSnippet = "Replace",
                },
                diagnostics = {
                    enable = true,
                    disable = {
                        "undefined-global",
                        "undefined-field",
                        "empty-block",
                        "missing-fields",
                        "inject-field"
                    },
                    --neededFileStatus = {
                    --    ['codestyle-check'] = 'Any',
                    --},
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "4",
                        quote_style = "double", -- double single
                        align_array_table = "false",
                    },
                },
            },
        },
    }
    --require("lspconfig").lua_ls.setup(opts)
    lsp_zero.configure("lua_ls", lsp_zero.nvim_lua_ls(opts))
end

function M.setup()
    local lsp_zero = require("lsp-zero")
    --lsp.set_log_level('debug')

    api.nvim_create_user_command("Format", function() require("lsp").format() end, {})

    vim.diagnostic.config({
        virtual_text = false,
        float = {
            show_header = true,
            source = "always",
            focusable = false,
            format = function(diagnostic)
                --vim.notify(vim.inspect(diagnostic))
                return string.format("%s\n[%s]", diagnostic.message, diagnostic.user_data.lsp.code)
            end,
        },
    })

    lsp_zero.extend_lspconfig()
    ---@diagnostic disable-next-line unused-local
    lsp_zero.on_attach(function(client, bufnr)
        --lsp_zero.default_keymaps({ buffer = bufnr })
        local opts = { buffer = bufnr }
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        --map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gD", vim.lsp.buf.declaration, opts)
        --map("n", "gi", vim.lsp.buf.implementation, opts)
        --map("n", "go", vim.lsp.buf.type_definition, opts)
        --map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "gs", vim.lsp.buf.signature_help, opts)
        map("n", "gl", vim.diagnostic.open_float, opts)
        map("n", "[d", vim.diagnostic.goto_prev, opts)
        map("n", "]d", vim.diagnostic.goto_next, opts)
        map("n", "<leader>ltd", '<cmd>lua require("lsp").diagnostic_toggle()<CR>', opts)
        map("n", "<leader>lf", "<cmd>lua require('lsp').format()<CR>", opts)
        map("v", "<leader>lf", "<cmd>lua require('lsp').format()<CR><ESC>", opts)
    end)

    for _, set in pairs(lsp_opts) do
        set()
    end

    lsp_zero.set_server_config({
        single_file_support = true,
    })

    require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = false,
        handlers = {
            function(server_name)
                if fn.index(Option.lsp, server_name) == -1 then
                    lsp_zero.default_setup(server_name)
                end
            end,
        }
    })

    -- not managed by mason
    lsp_zero.default_setup("qmlls")
end

return M
