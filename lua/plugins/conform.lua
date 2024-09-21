return {
    "stevearc/conform.nvim",
    lazy = true,
    config = function()
        require("conform").setup({
            default_format_opts = {
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                -- c = { "astyle" },
                -- cpp = { "astyle" },
            },
            formatters = {
                astyle = {
                    inherit = false,
                    command = "astyle",
                    args = Formats.astyle,
                },
            },
        })
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end
}
