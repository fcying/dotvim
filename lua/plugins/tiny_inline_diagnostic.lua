local opts = {
    options = {
        show_source = true,
        format = function(diagnostic)
            return string.format("%s[%s]", diagnostic.message, diagnostic.user_data.lsp.code)
        end,
    }
}

return {
    "rachartier/tiny-inline-diagnostic.nvim",
    -- event = "LspAttach",
    event = "VeryLazy",
    config = function()
        require("tiny-inline-diagnostic").setup(opts)
    end,
}
