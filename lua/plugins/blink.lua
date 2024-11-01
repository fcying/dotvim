local opts = {
    highlight = {
        use_nvim_cmp_as_default = true,
    },
    nerd_font_variant = "normal",
    keymap = {
        ["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "select_and_accept" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },
    sources = {
        completion = {
            enabled_providers = { "lsp", "path", "snippets", "buffer", "dictionary" },
        },
        providers = {
            snippets = {
                name = "Snippets",
                module = "blink.cmp.sources.snippets",
                score_offset = -3,
                opts = {
                    friendly_snippets = true,
                    search_paths = { vim.g.config_dir .. "/snippets" },
                    global_snippets = { "all" },
                    extended_filetypes = {},
                    ignored_filetypes = {},
                },
            },
            dictionary = {
                name = "dictionary",
                module = "blink.compat.source",
                score_offset = 3,
                opts = {
                    { name = "dictionary" },
                }
            },
        },
    },
}

return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
        "rafamadriz/friendly-snippets",
        { "saghen/blink.compat", opts = { impersontate_nvim_cmp = true, } },
        { import = "plugins.cmp_dictionary" },
    },
    version = "*",
    -- build = "cargo build --release",
    opts = opts,
}
