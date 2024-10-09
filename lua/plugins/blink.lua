return {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",

    version = nil,
    build = 'cargo build --release',

    opts = {
        highlight = {
            use_nvim_cmp_as_default = true,
        },
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "normal",
        -- accept = { auto_brackets = { enabled = true } },
        trigger = { signature_help = { enabled = true } },

        keymap = {
            show = "<C-l>",
            hide = "<C-e>",
            accept = "<CR>",
            select_prev = { "<Up>", "<C-p>", "<S-Tab>" },
            select_next = { "<Down>", "<C-n>", "<Tab>" },

            show_documentation = {},
            hide_documentation = {},
            scroll_documentation_up = "<C-b>",
            scroll_documentation_down = "<C-f>",

            snippet_forward = "<Tab>",
            snippet_backward = "<S-Tab>",
        },
        sources = {
            providers = {
                {
                    { "blink.cmp.sources.lsp" },
                    { "blink.cmp.sources.path" },
                    {
                        "blink.cmp.sources.snippets",
                        score_offset = -3,
                        opts = {
                            friendly_snippets = false,
                            -- search_paths = { vim.g.config_dir .. "/snippets" },
                            global_snippets = { "all" },
                            extended_filetypes = {},
                            ignored_filetypes = {},
                        },
                    },
                },
                { { "blink.cmp.sources.buffer" } },
            },
        },
    }
}
