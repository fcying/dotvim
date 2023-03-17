local g, api, cmd = vim.g, vim.api, vim.cmd

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "fcying/telescope-ctags-outline.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = g.make },
    },
    cmd = "Telescope",
    keys = {
        { "fb",         "<cmd>Telescope buffers<cr>" },
        { "ff",         ":<C-u><C-R>=g:find_command<CR><CR>",              silent = true },
        { "fg",         "<cmd>Telescope grep_string<cr><TAB>" },
        { "fg",         "<cmd>Telescope grep_string<cr><TAB>",             mode = "v" },
        { "fh",         "<cmd>Telescope help_tags<cr>" },
        { "fj",         "<cmd>Telescope jumplist<cr>" },
        { "fl",         "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
        { "fm",         "<cmd>Telescope oldfiles<cr>" },
        { "fn",         "<cmd>Telescope notify<cr>" },
        { "fo",         "<cmd>Telescope ctags_outline outline<CR>" },
        { "<leader>fo", "<cmd>Telescope ctags_outline outline buf=all<CR>" },
        { "fr",         "<cmd>Telescope resume<cr><tab>" },
        { "ft",         "<cmd>Telescope tags<cr>" },
        { "f/",         "<cmd>Telescope live_grep<cr>" },
        { "gI",         "<cmd>Telescope lsp_implementations<cr>" },
        { "gr",         "<cmd>Telescope lsp_references<cr>" },
        { "gt",         "<cmd>Telescope lsp_type_definitions<cr>" },
        { "<leader>la", "<cmd>Telescope lsp_code_actions<cr>" },
        { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>" },
        { "<leader>lo", "<cmd>Telescope ctags_outline outline<cr>" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>" },
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
