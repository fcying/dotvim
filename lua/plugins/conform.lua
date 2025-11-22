return {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>lf",
            function()
                require("conform").format()
            end,
            desc = "Format Document",
            mode = { "n", "v" },
        },
    },
    config = function()
        require("conform").setup({
            default_format_opts = {
                timeout_ms = 5000,
            },
            -- format_after_save = {
            --     timeout_ms = 5000,
            -- },
            notify_on_error = true,
            formatters_by_ft = {
                -- lua = { "stylua" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                -- run formatters that don't have other formatters configured.
                ["_"] = { "trim_whitespace", lsp_format = "last" },
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
                ["clang_format"] = {
                    -- inherit = false,
                    command = "clang-format",
                    args = Formats["clang-format"],
                },
            },
        })
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end
}
