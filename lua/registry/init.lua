if vim.fn.has("linux") == 1 then
    return {
        ["clangd"] = "registry.clangd",
        ["lua-language-server"] = "registry.lua_ls",
        --["AAATest"] = "registry.lua_ls",
    }
else
    return {}
end
