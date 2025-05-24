return {
    "aznhe21/actions-preview.nvim",
    lazy = true,
    config = function()
        require("actions-preview").setup({
            backend = { "snacks", "telescope", "minipick", "nui" },
        })
    end
}
