return {
    "stevearc/conform.nvim",
    lazy = true,
    config = function()
        require("conform").setup({
            default_format_opts = {
                timeout_ms = 5000,
                lsp_format = "fallback", -- fallback never
            },
            -- format_after_save = {
            --     timeout_ms = 5000,
            --     lsp_format = "fallback",
            -- },
            notify_on_error = true,
            formatters_by_ft = {
                -- lua = { "stylua" },
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            formatters = {
                stylua = {
                    inherit = false,
                    command = "stylua",
                    args = Formats.stylua,
                },
                astyle = {
                    inherit = false,
                    command = "astyle",
                    args = Formats.astyle,
                },
                ["clang-format"] = {
                    inherit = false,
                    command = "clang-format",
                    args = Formats["clang-format"],
                },
            },
        })
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end
}
