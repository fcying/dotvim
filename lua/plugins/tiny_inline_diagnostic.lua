local opts = {
    options = {
        show_source = false,
        format = function(diagnostic)
            if diagnostic.user_data.lsp.code then
                return string.format("%s [%s]", diagnostic.message, diagnostic.user_data.lsp.code)
            else
                return string.format("%s", diagnostic.message)
            end
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
