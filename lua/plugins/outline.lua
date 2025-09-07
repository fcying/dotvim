return {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    dependencies = {
        "epheien/outline-ctags-provider.nvim"
    },
    opts = {
        providers = {
            priority = { "lsp", "coc", "markdown", "norg", "ctags" },
            ctags = {
                program = "ctags",
                filetypes = {
                },
            },
        },
    },
}
