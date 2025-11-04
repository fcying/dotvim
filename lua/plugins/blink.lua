-- single rounded
local border = "rounded"

local dict_opts = {
    get_command = "rg",
    get_command_args = function(prefix, _)
        local rg_opts = {
            "--no-config",
            "--color=never",
            "--no-line-number",
            "--no-messages",
            "--no-filename",
            "--smart-case",
            "--",
            prefix,
        }
        local dict_path = vim.g.config_dir .. "/dict/"
        -- local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        local new_dict
        -- if name:find(".*xmake.lua") then
        --     new_dict = dict_path .. "xmake.dict"
        -- else
        --     new_dict = dict_path .. vim.bo.filetype .. ".dict"
        -- end
        new_dict = dict_path .. vim.bo.filetype .. ".dict"
        if vim.loop.fs_stat(new_dict) then
            table.insert(rg_opts, new_dict)
        end
        table.insert(rg_opts, dict_path .. "dictionary")
        return rg_opts
    end
}

local snippets = {
    -- name = "default",
    name = "luasnip",
    default = {
        name = "Snippets",
        module = "blink.cmp.sources.snippets",
        opts = {
            search_paths = { vim.g.config_dir .. "/snippets" },
        },
    },
    luasnip = {}
}

---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = { -- {{{
    keymap = {
        preset = "enter",
        ["<C-space>"] = {},
        ["<C-e>"] = { "show", "hide", "show_documentation", "hide_documentation" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-j>"] = { "snippet_forward", "fallback" },
        ["<C-k>"] = { "snippet_backward", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    signature = {
        enabled = true,
        window = { border = border },
    },
    snippets = {
        preset = snippets.name
    },
    appearance = {
        use_nvim_cmp_as_default = true,
    },
    completion = {
        documentation = {
            auto_show = true,
            window = { border = border },
        },
        trigger = {
            show_on_x_blocked_trigger_characters = { "'", '"', "(", "{" },
        },
        list = {
            selection = { preselect = false, auto_insert = false },
        },
    },
    fuzzy = {
        implementation = vim.g.blink_impl == "rust" and "prefer_rust_with_warning" or "lua",
    },
    sources = {
        default = { "lsp", "path", "dictionary", "buffer", "snippets", "lazydev" },
        providers = {
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100, },
            snippets = snippets.name == "default" and snippets.default or snippets.luasnip,
            dictionary = {
                module = "blink-cmp-dictionary",
                name = "Dict",
                min_keyword_length = 3,
                opts = dict_opts,
            }
        },
    },
    cmdline = {
        completion = {
            menu = {
                auto_show = function()
                    return vim.fn.getcmdtype() == ":"
                end,
            },
            list = {
                selection = {
                    preselect = false,
                },
            },
        },
        keymap = {
            ["<CR>"] = {
                function(cmp)
                    return cmp.accept {
                        callback = function()
                            vim.api.nvim_feedkeys("\n", "n", true)
                        end,
                    }
                end,
                "fallback",
            },
            ["C-f"] = { "accept", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
        },
    },
}

return {
    "saghen/blink.cmp",
    event = { "CursorHold", "CursorHoldI", "CmdlineEnter" },
    dependencies = {
        { import = "plugins.luasnip" },
        "Kaiser-Yang/blink-cmp-dictionary",
        "rafamadriz/friendly-snippets",
    },
    version = "v1.*",
    -- build = "cargo build --release",
    opts = opts,
}
