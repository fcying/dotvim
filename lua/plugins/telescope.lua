local g, api, cmd = vim.g, vim.api, vim.cmd

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "fcying/telescope-ctags-outline.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = g.make },
    },
    cmd = { "Telescope" },
    keys = {
        {
            "fb",
            "<cmd>Telescope buffers<cr>",
            desc = "buffer"
        },
        {
            "ff",
            ":<C-u><C-R>=g:find_command<CR><CR>",
            desc = "file",
            silent = true
        },
        {
            "fg",
            "<cmd>Telescope grep_string<cr>",
            desc = "string"
        },
        {
            "fg",
            "<cmd>Telescope grep_string<cr>",
            desc = "string",
            mode = "v"
        },
        { "fh", "<cmd>Telescope help_tags<cr>",                     desc = "help" },
        { "fj", "<cmd>Telescope jumplist<cr>",                      desc = "jumplist" },
        { "fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "line" },
        { "fm", "<cmd>Telescope oldfiles<cr>",                      desc = "mru" },
        { "fn", "<cmd>Telescope notify<cr>",                        desc = "notify" },
        { "fo", "<cmd>Telescope ctags_outline outline<CR>",         desc = "outline" },
        { "fO", "<cmd>Telescope ctags_outline outline buf=all<CR>", desc = "all buf outline" },
        { "fr", "<cmd>Telescope resume<cr>",                        desc = "resume" },
        { "ft", "<cmd>Telescope tags<cr>",                          desc = "tag" },
        { "f/", "<cmd>Telescope live_grep<cr>",                     desc = "live grep" },
        { "gI", "<cmd>Telescope lsp_implementations<cr>",           desc = "lsp_implementations" },
        {
            "gr",
            "<cmd>Telescope lsp_references include_current_line=true<cr>",
            desc = "lsp_references"
        },
        { "gt",         "<cmd>Telescope lsp_type_definitions<cr>", desc = "lsp_type_definitions" },
        { "<leader>la", "<cmd>Telescope lsp_code_actions<cr>",     desc = "lsp_code_actions" },
        { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>",  desc = "lsp diagnostics" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "lsp_document_symbols" },
    },
    config = function()
        local actions = require("telescope.actions")
        local toggle_modes = function()
            local mode = api.nvim_get_mode().mode
            if mode == "n" then
                cmd([[startinsert]])
                return
            elseif mode == "i" then
                cmd([[stopinsert]])
                return
            end
        end
        require("telescope").setup({
            defaults = {
                --horizontal vertical flex center
                layout_strategy = "vertical",
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<c-j>"] = actions.move_selection_next,
                        ["<c-k>"] = actions.move_selection_previous,
                        ["<tab>"] = toggle_modes,
                        ["<c-s>"] = actions.toggle_selection,
                        ["<C-q>"] = actions.send_to_qflist.open_qflist,
                    },
                    n = {
                        ["q"]     = actions.close,
                        ["<tab>"] = toggle_modes,
                        ["<c-s>"] = actions.toggle_selection,
                        ["<C-q>"] = actions.send_to_qflist.open_qflist,
                    },
                },
            },
            pickers = {
                resume = { initial_mode = "normal", },
                grep_string = { initial_mode = "normal", },
                lsp_implementations = { initial_mode = "normal", },
                lsp_references = { initial_mode = "normal", },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    -- smart_case ignore_case respect_case
                    case_mode = "smart_case",
                },
                ctags_outline = {
                    ctags = { "ctags", g.ctags_opt },
                    ft_opt = {
                        c = "--c-kinds=f",
                        cpp = "--c++-kinds=f --language-force=C++",
                        vim = "--vim-kinds=fk",
                        sh = "--sh-kinds=fk",
                        zsh = "--sh-kinds=fk",
                        lua = "--lua-kinds=fk",
                    },
                },
            },
        })
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("ctags_outline")
        require("util").telescope_update_ignore()
    end,
}
