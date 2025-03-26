---@module 'blink.cmp'
---@type blink.cmp.Config

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
        local dict_ft = dict_path .. vim.bo.filetype .. ".dict"
        if vim.loop.fs_stat(dict_ft) then
            table.insert(rg_opts, dict_ft)
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

local opts = {
    enabled = function()
        return vim.bo.buftype ~= "prompt"
    end,
    keymap = {
        preset = "enter",
        ["<C-space>"] = {},
        ["<C-e>"] = { "show", "hide", "show_documentation", "hide_documentation" },
        ["<S-Tab>"] = { "select_prev", "snippet_forward", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    signature = {
        enabled = true,
        window = { border = border },
    },
    snippets = {
        preset = snippets.name
    },
    completion = {
        documentation = {
            auto_show = true,
            window = { border = border },
        },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "dictionary" },
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
}

return {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        { import = "plugins.luasnip" },
        "Kaiser-Yang/blink-cmp-dictionary",
        "rafamadriz/friendly-snippets",
    },
    version = "v1.*",
    -- build = "cargo build --release",
    opts = opts,
}
