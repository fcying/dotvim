local g, fn = vim.g, vim.fn
local util = require("util")
local map = util.map
local M = {}
local configs = {}
local system_lsp = { "qmlls", "nushell" }

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
    map("n", "grr", function() Snacks.picker.lsp_references({ include_current = true }) end, opts)
    map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)
    map("n", "gs", vim.lsp.buf.signature_help, opts)
    map("n", "gl", vim.diagnostic.open_float, opts)
    map("n", "<leader>ld", function() Snacks.picker.diagnostics_buffer() end, opts)
    map("n", "<leader>lr", "<cmd>LspRestart<CR>", opts)

    --client.server_capabilities.semanticTokensProvider = nil
end

function configs.qmlls()
    local opts = {
        cmd = { "qmlls", "--build-dir", util.root_dir .. "/build" },
        filetypes = { "qml", "qmljs" },
    }
    vim.lsp.config("qmlls", opts)
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
        table.insert(clangd_cmd, "--query-driver=" .. Option.clangd_query_driver)
    end
    if Option.compile_commands_dir ~= nil then
        table.insert(clangd_cmd, "--compile-commands-dir=" .. Option.compile_commands_dir)
    elseif g.gencconf_storein_rootmarker == 1 then
        table.insert(clangd_cmd, "--compile-commands-dir=" .. util.root_marker)
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("clangd_keymap", { clear = true }),
        pattern = { "c", "cpp", },
        callback = function()
            local opts = { buffer = vim.api.nvim_get_current_buf() }
            map("n", "<leader>h", "<cmd>LspClangdSwitchSourceHeader<cr>", opts)
        end,
    })

    vim.lsp.config("clangd", {
        cmd = clangd_cmd,
        root_markers = { ".root", ".git" },
    })
end

function configs.autohotkey2_lsp()
    local function get_autohotkey_path()
        local path = vim.fn.exepath("AutoHotkey64.exe")
        return #path > 0 and path or ""
    end
    local package_path = vim.fn.expand("$MASON/packages/autohotkey2-lsp/autohotkey2-lsp")
    local opts = {
        cmd = { "node", package_path .. "/server/dist/server.js", "--stdio" },
        filetypes = { "ahk", "autohotkey", "ah2", "ahk2" },
        init_options = {
            locale = "en-us",
            InterpreterPath = get_autohotkey_path(),
        },
    }
    vim.lsp.config("autohotkey_lsp", opts)
end

function configs.bashls()
    local opts = {
        filetypes = { "sh", "zsh" },
        settings = {
            bashIde = {
                shellcheckArguments = "-e SC1090,SC1091,SC1094,SC2010,SC2012,SC2015,SC2029,SC2046,SC2086,"
                    .. "SC2119,SC2120,SC2154,SC2155,SC2164,SC2181,SC2206,SC2317",
            }
        },
        single_file_support = true,
    }
    vim.lsp.config("bashls", opts)
end

function configs.nushell()
    local opts = {
        cmd = {
            "nu",
            "-I",
            vim.fn.getcwd(),
            "--no-config-file",
            "--lsp",
        },
        filetypes = { "nu" },
        single_file_support = true,
    }
    vim.lsp.config("nushell", opts)
end

function configs.gopls()
    local opts = {
        root_markers = { ".root", "go.mod", ".git" },
        settings = {
            gopls = {
                semanticTokens = true,
                analyses = {
                    unusedparams = false,
                },
            }
        },
    }
    vim.lsp.config("gopls", opts)
end

function configs.python()
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
    vim.lsp.config("pylsp", opts)
end

function configs.lua()
    -- :lua vim.print(vim.lsp.get_clients({ name = "lua_ls" })[1].config.settings.Lua)
    -- vim.g.lazydev_enabled = false
    local opts = {
        settings = {
            root_markers = {
                ".root",
                ".luarc.json",
                ".luarc.jsonc",
                ".luacheckrc",
                ".stylua.toml",
                "stylua.toml",
                "selene.toml",
                "selene.yml",
                ".git",
            },
            Lua = {
                semantic = {
                    enable = true,
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.g.config_dir .. "/lua",
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

    vim.lsp.config("lua_ls", opts)
end

function configs.ts_ls()
    local vue_typescript_plugin = vim.fn.expand(
        "$MASON/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin")
    local opts = {
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
        root_markers = { ".root", "tsconfig.json", "jsconfig.json", "package.json", ".git" },
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

    vim.lsp.config("ts_ls", opts)
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

    require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_enable = {
            exclude = Option.lsp,
        },
    })

    for _, lsp in ipairs(system_lsp) do
        vim.lsp.enable(lsp)
    end
end

return M
