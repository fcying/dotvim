local opts = {
    ["autohotkey2-lsp"] = "registry.autohotkey2",
}

if vim.fn.has("linux") == 1 then
    opts = vim.tbl_extend("force", opts, {
        ["clangd"] = "registry.clangd",
        ["lua-language-server"] = "registry.lua_ls",
    })
end

return opts
