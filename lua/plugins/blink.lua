---@module 'blink.cmp'
---@type blink.cmp.Config
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
        cmdline = {
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
        },
    },
    completion = {
        list = {
            selection = {
                preselect = function(ctx) return ctx.mode ~= "cmdline" end,
                auto_insert = function(ctx) return ctx.mode == "cmdline" end
            },
        },
        trigger = {
            -- show_on_trigger_character = true,
            show_on_x_blocked_trigger_characters = { "'", '"', "(", "{" },
        },
    },
    signature = {
        enabled = true,
        window = {
            border = "rounded",
        },
    },
    snippets = {
        expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
            if filter and filter.direction then
                return require("luasnip").locally_jumpable()
            end
            return require("luasnip").in_snippet()
        end,
        jump = function(direction)
            require("luasnip").jump(direction)
        end,
    },
    sources = {
        -- cmdline = {},
        default = { "lsp", "path", "snippets", "buffer", "lazydev", "dictionary" },
        providers = {
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
            snippets = {
                name = "Snippets",
                module = "blink.cmp.sources.snippets",
                opts = {
                    friendly_snippets = true,
                    search_paths = { vim.g.config_dir .. "/snippets" },
                },
            },
            dictionary = {
                name = "dictionary",
                module = "blink.compat.source",
                score_offset = 3,
                min_keyword_length = 2,
            },
        },
    },
}

return {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        { "saghen/blink.compat", lazy = true, opts = { impersontate_nvim_cmp = true, } },
        { import = "plugins.cmp_dictionary" },
        { import = "plugins.luasnip" },
        { "saadparwaiz1/cmp_luasnip" },
        -- "rafamadriz/friendly-snippets",
    },
    version = "v0.*",
    build = "cargo build --release",
    opts = opts,
}
