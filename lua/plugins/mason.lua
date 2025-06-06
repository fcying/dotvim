return {
    "mason-org/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    dependencies = {
        { "mason-org/mason-lspconfig.nvim" },
    },
    config = function()
        require("mason").setup({
            install_root_dir = vim.g.runtime_dir .. "/mason",
            --pip = {
            --    install_args = { "-i", "https://pypi.tuna.tsinghua.edu.cn/simple" },
            --},
            registries = {
                "github:fcying/my-mason-registry",
                "github:mason-org/mason-registry",
            },
        })
    end
}
