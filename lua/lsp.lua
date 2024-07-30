local g, cmd, fn, lsp, api = vim.g, vim.cmd, vim.fn, vim.lsp, vim.api
local util = require("util")
local map = util.map
local M = {}
local configs = {}
local lsp_opts = {}

local formats = {
    stylua = {
        "--indent-type", "Spaces",
        "--indent-width", "4",
        "--quote-style", "AutoPreferDouble", -- AutoPreferDouble, AutoPreferSingle, ForceDouble, ForceSingle
    },
    astyle = {
        "-A1", "--lineend=linux",
        "--convert-tabs", "--suffix=none", "--add-braces", "--max-code-length=120",
        "--min-conditional-indent=0", "--max-continuation-indent=100",
        "--indent=spaces=4", "--indent-switches", "--indent-namespaces",
        "--indent-labels", "--indent-preproc-define",
        "--pad-oper", "--pad-header",
        "--align-pointer=name", "--align-reference=name",
    },
}

local diagnostics_on = true
function M.diagnostic_toggle()
    if diagnostics_on then
        vim.notify("disable diagnostics")
        vim.diagnostic.enable(false)
    else
        vim.notify("enable diagnostics")
        vim.diagnostic.enable(true)
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

function M.conform()
    return {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        config = function()
            require("conform").setup({
                default_format_opts = {
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    -- c = { "astyle" },
                    -- cpp = { "astyle" },
                },
                formatters = {
                    astyle = {
                        inherit = false,
                        command = "astyle",
                        args = formats.astyle,
                    },
                },
            })
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end
    }
end

function M.format()
    require("conform").format()
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

function configs.qmlls()
    local lsp_util = require("lspconfig/util")
    lsp_opts["qmlls"] = {
        cmd = { "qmlls", "--build-dir", util.root_dir .. "/build" },
        filetypes = { "qml" },
        root_dir = function(fname)
            return lsp_util.find_git_ancestor(fname)
        end,
    }
end

function configs.clangd()
    local clangd_cmd = {
        "clangd",
        "--background-index",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=never",      -- iwyu never
        "--pch-storage=memory",
    }
    if Option.clangd_query_driver then
        table.insert(clangd_cmd, "--query-driver=" .. g.clangd_query_driver)
    end
    if Option.compile_commands_dir ~= nil then
        table.insert(clangd_cmd, "--compile-commands-dir=" .. Option.compile_commands_dir)
    elseif g.gencconf_storein_rootmarker == 1 then
        table.insert(clangd_cmd, "--compile-commands-dir=" .. util.root_marker)
    end

    cmd([[ autocmd myau FileType c,cpp nnoremap <silent> <buffer> <Leader>h <ESC>:ClangdSwitchSourceHeader<CR> ]])

    lsp_opts["clangd"] = {
        cmd = clangd_cmd,
        --handlers = { ['textDocument/publishDiagnostics'] = diagnostics_config(0) },
    }
end

function configs.ahk2()
    local path = require("mason-core.path").package_prefix("autohotkey2-lsp")
    local InterpreterPath = "AutoHotkey64.exe"
    if fn.has("linux") == 1 then
        InterpreterPath = fn.expand("$HOME/bin/") .. InterpreterPath
    end
    local opts = {
        cmd = { "node", path .. "/autohotkey2-lsp/server/dist/server.js", "--stdio" },
        filetypes = { "ahk", "autohotkey", "ah2", "ahk2" },
        init_options = {
            locale = "en-us",
            InterpreterPath = InterpreterPath,
        },
        root_dir = function()
            return util.root_dir
        end,
    }
    require("lspconfig.configs")["autohotkey2-lsp"] = { default_config = opts }
end

function configs.bashls()
    lsp_opts["bashls"] = {
        filetypes = { "sh", "zsh" },
        settings = {
            bashIde = {
                shellcheckArguments = "-e SC1090,SC1091,SC1094,SC2010,SC2012,SC2015,SC2029,SC2046,SC2086,"
                    .. "SC2119,SC2120,SC2154,SC2155,SC2164,SC2181,SC2206,SC2317",
            }
        }
    }
end

function configs.gopls()
    local lsp_util = require("lspconfig/util")
    lsp_opts["gopls"] = {
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
end

function configs.python()
    lsp_opts["pylsp"] = {
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
end

function configs.lua()
    -- :lua vim.print(vim.lsp.get_clients({ name = "lua_ls" })[1].config.settings.Lua)
    local opts = {
        settings = {
            Lua = {
                workspace = { checkThirdParty = false, },
                completion = { callSnippet = "Replace", },
                diagnostics = {
                    globals = { "vim" },
                    enable = true,
                    disable = {
                        "undefined-global",
                        "undefined-field",
                        "empty-block",
                        "missing-fields",
                        "inject-field",
                        "lowercase-global",
                    },
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

    local filename = vim.fn.expand("%:t")
    if filename == ".nvim.lua" or vim.uv.fs_stat(util.root_dir .. "/lua") then
        opts.settings.Lua.workspace.library = {
            g.config_dir .. "/lua",
        }
        -- local lsp_zero = require("lsp-zero")
        -- lsp_opts["lua_ls"] = lsp_zero.nvim_lua_ls(opts)
        lsp_opts["lua_ls"] = opts
    end
end

function M.setup()
    local lsp_zero = require("lsp-zero")
    --lsp.set_log_level('debug')

    api.nvim_create_user_command("Format", function() require("lsp").format() end, {})

    vim.diagnostic.config({
        virtual_text = false,
        float = {
            show_header = true,
            source = true,
            focusable = false,
            format = function(diagnostic)
                --vim.print(diagnostic)
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

        --client.server_capabilities.semanticTokensProvider = nil
    end)

    for _, set in pairs(configs) do
        set()
    end

    lsp_zero.set_server_config({
        single_file_support = true,
    })

    local mason_server = require("mason-lspconfig.mappings.server")
    mason_server.package_to_lspconfig["autohotkey2-lsp"] = "autohotkey2-lsp"

    require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = false,
        handlers = {
            function(server_name)
                -- vim.print(server_name)
                if fn.index(Option.lsp, server_name) ~= -1 then
                    return
                elseif lsp_opts[server_name] ~= nil then
                    lsp_zero.configure(server_name, lsp_opts[server_name])
                else
                    lsp_zero.default_setup(server_name)
                end
            end,
        }
    })

    -- not managed by mason
    if fn.executable("qmlls") == 1 then
        lsp_zero.configure("qmlls", lsp_opts["qmlls"])
    end
end

return M
