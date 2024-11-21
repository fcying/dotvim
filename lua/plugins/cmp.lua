local cmp_opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    cmp.setup({
        inlay_hints = { enabled = true },
        preselect = cmp.PreselectMode.None,
        completion = {
            completeopt = vim.o.completeopt,
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
                -- vim.snippet.expand(args.body)
            end,
        },
        mapping = {
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-l>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            -- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close(), }),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),
        },
        sources = cmp.config.sources({
            { name = "lazydev", group_index = 0 },     -- set group index to 0 to skip loading LuaLS completions
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "async_path" },
            { name = "dictionary" },
            { name = "buffer" },
            -- { name = "tags" },
            -- { name = "omni", priority = -1 },
        }),
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = ({
                    buffer = "[Buf]",
                    async_path = "[Path]",
                    cmdline = "[Cmd]",
                    nvim_lsp = "[Lsp]",
                    tags = "[Tag]",
                    tmux = "[Tmux]",
                    luasnip = "[Snip]",
                    dictionary = "[Dict]",
                    -- omni = "[Omni]",
                    cmdline_history = "[History]",
                })[entry.source.name]
                -- vim_item.dup = ({
                --     nvim_lsp = 0,
                --     buffer = 1,
                --     async_path = 1,
                -- })[entry.source.name] or 0
                return vim_item
            end,
        },
    })

    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "buffer" },
        }),
    })

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "buffer" },
            { name = "cmdline_history" },
        }),
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "async_path" },
            { name = "cmdline" },
            { name = "cmdline_history" },
        }),
    })
end

return {
    "hrsh7th/nvim-cmp",
    -- "iguanacucumber/magazine.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "FelipeLema/cmp-async-path", url = "https://codeberg.org/FelipeLema/cmp-async-path" },
        -- { "FelipeLema/cmp-async-path", url = "https://codeberg.org/fcying/cmp-async-path" },
        { "hrsh7th/cmp-cmdline" },
        { "dmitmel/cmp-cmdline-history" },
        -- { "hrsh7th/cmp-omni" },
        -- { "quangnguyen30192/cmp-nvim-tags" },
        { import = "plugins.cmp_dictionary" },
        { import = "plugins.luasnip" },
    },
    config = cmp_opts,
}
