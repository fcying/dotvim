return {
    "fcying/gen_clang_conf.vim",
    -- lazy = false,
    ft = { "cpp", "c" },
    init = function()
        vim.g.gencconf_storein_rootmarker = vim.g.gencconf_storein_rootmarker or 1
    end
}
