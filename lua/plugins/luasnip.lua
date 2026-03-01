local luasnip_opts = function()
    local paths = {}
    paths[#paths + 1] = vim.g.config_dir .. "/snippets"
    paths[#paths + 1] = vim.g.plug_dir .. "/friendly-snippets"
    require("luasnip").config.setup({ enable_autosnippets = true })
    require("luasnip.loaders.from_vscode").lazy_load({ paths = paths })
end

return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = vim.g.is_win and nil or vim.g.make .. " install_jsregexp",
    config = luasnip_opts,
    dependencies = { "rafamadriz/friendly-snippets" }
}
