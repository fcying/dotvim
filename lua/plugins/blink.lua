---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
    highlight = {
        use_nvim_cmp_as_default = true,
    },
    nerd_font_variant = "normal",
    keymap = {
        preset = "enter",
        ["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-space>"] = {},
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    },
    -- accept = { auto_brackets = { enabled = true } },
    trigger = {
        completion = {
            show_in_snippet = true,
        },
        signature_help = { enabled = false },
    },
    sources = {
        completion = {
            enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev", "dictionary" },
        },
        providers = {
            lsp = {
                min_keyword_length = 0,
                -- dont show LuaLS require statements when lazydev has items
                fallback_for = { "lazydev" },
            },
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
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
        "rafamadriz/friendly-snippets",
        { "saghen/blink.compat", opts = { impersontate_nvim_cmp = true, } },
        { import = "plugins.cmp_dictionary" },
    },
    -- version = "v0.*",
    build = "cargo build --release",
    opts = opts,
}
