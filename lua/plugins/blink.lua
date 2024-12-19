---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
    enabled = function()
        return vim.bo.buftype ~= "prompt"
    end,
    keymap = {
        preset = "enter",
        ["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-space>"] = {},
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    },
    completion = {
        accept = { auto_brackets = { enabled = false }, },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true },
    },
    snippets = {
        -- expand = function(snippet) vim.snippet.expand(snippet) end,
        -- active = function(filter) return vim.snippet.active(filter) end,
        -- jump = function(direction) vim.snippet.jump(direction) end,
        expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
        active = function(filter)
            if filter and filter.direction then
                require("luasnip").jumpable(filter.direction)
            end
            return require("luasnip").in_snippet()
        end,
        jump = function(direction) require("luasnip").jump(direction) end,
    },
    sources = {
        default = { "lsp", "path", "luasnip", "buffer", "lazydev", "dictionary" },
        cmdline = {},
        providers = {
            lsp = { min_keyword_length = 0, },
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
            luasnip = {
                name = "luasnip",
                module = "blink.compat.source",
                score_offset = -3,
                min_keyword_length = 2,
                opts = {
                    use_show_condition = false,
                    show_autosnippets = true,
                },
            },
            snippets = {
                name = "Snippets",
                module = "blink.cmp.sources.snippets",
                score_offset = -3,
                min_keyword_length = 2,
                opts = {
                    friendly_snippets = true,
                    search_paths = { vim.g.config_dir .. "/snippets" },
                    global_snippets = { "all" },
                    extended_filetypes = {},
                    ignored_filetypes = {},
                },
            },
            buffer = { min_keyword_length = 2, },
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
