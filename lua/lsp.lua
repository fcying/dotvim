local g, cmd, fn, lsp = vim.g, vim.cmd, vim.fn, vim.lsp
local util = require("util")
local map = util.map
local M = {}
local configs = {}
local lsp_opts = {}

Formats = {
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
    ["clang-format"] = {
        -- "--style=file:" .. vim.g.config_dir .. "/etc/.clang-format",
    },
}

local lspAttch = function(args)
    local opts = { buffer = args.buf }
    --map("n", "gd", vim.lsp.buf.definition, opts) -- define in util.lua
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gri", function() Snacks.picker.lsp_implementations() end, opts)
    map("n", "grr", function() Snacks.picker.lsp_references({include_current = true}) end, opts)
    map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)
    map("n", "gs", vim.lsp.buf.signature_help, opts)
    map("n", "gl", vim.diagnostic.open_float, opts)
    map("n", "[d", function() vim.diagnostic.goto_next({ float = false }) end, opts)
    map("n", "]d", function() vim.diagnostic.goto_next({ float = false }) end, opts)
    map("n", "<leader>ld", function() Snacks.picker.diagnostics_buffer() end, opts)
    map("n", "<leader>lr", "<cmd>LspRestart<CR>", opts)

    --client.server_capabilities.semanticTokensProvider = nil
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
                formatting.astyle.with({ extra_args = Formats.astyle }),
                --formatting.stylua.with({ extra_args = Formats.stylua }),
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
        "--header-insertion=never", -- iwyu never
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
        single_file_support = true,
    }
    require("lspconfig.configs")["autohotkey2-lsp"] = { default_config = opts }
    lsp_opts["autohotkey2-lsp"] = opts
end

function configs.bashls()
    lsp_opts["bashls"] = {
        filetypes = { "sh", "zsh" },
        settings = {
            bashIde = {
                shellcheckArguments = "-e SC1090,SC1091,SC1094,SC2010,SC2012,SC2015,SC2029,SC2046,SC2086,"
                    .. "SC2119,SC2120,SC2154,SC2155,SC2164,SC2181,SC2206,SC2317",
            }
        },
        single_file_support = true,
    }
end

function configs.nushell()
    lsp_opts["nushell"] = {
        cmd = {
            "nu",
            "-I",
            vim.fn.getcwd(),
            "--no-config-file",
            "--lsp",
        },
        filetypes = { "nu" },
        root_dir = function() return util.root_dir end,
        single_file_support = true,
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
    -- vim.g.lazydev_enabled = false
    local opts = {
        root_dir = function(_)
            return util.root_dir
        end,
        settings = {
            Lua = {
                semantic = {
                    enable = true,
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        g.config_dir .. "/lua",
                    },
                },
                completion = {
                    callSnippet = "Replace",
                    autoRequire = false,
                },
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

    lsp_opts["lua_ls"] = opts
end

function configs.ts_ls()
    local lsp_util = require("lspconfig/util")
    local vue_typescript_plugin = require("mason-registry")
        .get_package("vue-language-server")
        :get_install_path()
        .. "/node_modules/@vue/language-server"
        .. "/node_modules/@vue/typescript-plugin"
    local opts = {
        root_dir = lsp_util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
        init_options = {
            hostInfo = "neovim",
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = vue_typescript_plugin,
                    languages = { "javascript", "typescript", "vue" },
                },
            },
        },
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
        },
        single_file_support = true,
    }

    lsp_opts["ts_ls"] = opts
end

function M.setup()
    -- lsp.set_log_level('debug')

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = lspAttch
    })

    for _, set in pairs(configs) do
        set()
    end

    -- diagnostic
    vim.diagnostic.config({
        virtual_text = false,
        float = {
            border = "rounded",
            source = false,
        }
    })

    local lspconfig = require("lspconfig")
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
                else
                    -- vim.lsp.config(server_name, lsp_opts[server_name] or {})
                    -- vim.lsp.enable(server_name)
                    lspconfig[server_name].setup(lsp_opts[server_name] or {})
                end
            end,
        }
    })

    -- not managed by mason
    lspconfig["qmlls"].setup(lsp_opts["qmlls"])
    lspconfig["nushell"].setup(lsp_opts["nushell"])
end

return M
