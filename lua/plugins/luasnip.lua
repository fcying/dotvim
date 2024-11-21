local luasnip_opts = function()
    local paths = {}
    paths[#paths + 1] = vim.g.config_dir .. "/snippets"
    paths[#paths + 1] = vim.g.plug_dir .. "/friendly-snippets"
    require("luasnip").config.setup({ enable_autosnippets = true })
    require("luasnip.loaders.from_vscode").lazy_load({ paths = paths })

    -- vim.cmd([[
    -- imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
    -- " -1 for jumping backwards.
    -- inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
    --
    -- snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
    -- snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
    --
    -- " For changing choices in choiceNodes (not strictly necessary for a basic setup).
    -- imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    -- smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    -- ]])
end

return {
    "L3MON4D3/LuaSnip",
    build = (vim.g.is_win == 0) and vim.g.make .. " install_jsregexp" or nil,
    config = luasnip_opts,
    dependencies = { "rafamadriz/friendly-snippets" }
}
