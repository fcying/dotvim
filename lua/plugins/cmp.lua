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

local cmp_dictionary = function()
    local dict_path = vim.g.config_dir .. "/dict/"
    local dict = {
        ["*"] = { dict_path .. "dictionary" },
        ["xmake"] = { dict_path .. "xmake.dict" },
        ["go"] = { dict_path .. "go.dict" },
        ["cmake"] = { dict_path .. "cmake.dict" },
    }

    local function get_dict_path(file)
        local paths = {}
        if file:find(".*xmake.lua") then
            paths = dict.xmake
        else
            paths = dict[vim.bo.filetype] or {}
        end
        vim.list_extend(paths, dict["*"])
        --vim.print(paths)
        return paths
    end

    require("cmp_dictionary").setup({
        paths = get_dict_path(vim.fn.expand("%")),
        exact_length = 2,
        first_case_insensitive = false,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(ev)
            require("cmp_dictionary").setup({ paths = get_dict_path(ev.file) })
        end,
    })
end

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
            { name = "omni", priority = -1 },
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
                    omni = "[Omni]",
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
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            build = (vim.g.is_win == 0) and vim.g.make .. " install_jsregexp" or nil,
            config = luasnip_opts,
            dependencies = { "rafamadriz/friendly-snippets" }
        },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        -- { "FelipeLema/cmp-async-path", url = "https://codeberg.org/FelipeLema/cmp-async-path" },
        { "FelipeLema/cmp-async-path", url = "https://codeberg.org/fcying/cmp-async-path" },
        { "hrsh7th/cmp-cmdline" },
        { "dmitmel/cmp-cmdline-history" },
        -- { "hrsh7th/cmp-omni" },
        -- { "quangnguyen30192/cmp-nvim-tags" },
        { "uga-rosa/cmp-dictionary", config = cmp_dictionary },
    },
    config = cmp_opts,
}
