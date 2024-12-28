local g, api, cmd = vim.g, vim.api, vim.cmd
local M = {}

function M.telescope_update_ignore()
    local util = require("util")
    local option = util.option
    util.find_command = "Telescope find_files "
    if g.has_rg == 1 then
        util.find_command = util.find_command .. "find_command=rg,--files,--no-ignore,--color=never"
        if option.rg ~= {} then
            util.find_command = util.find_command .. "," .. table.concat(option.rg, ",")
        end
    end

    if _G["TelescopeGlobalState"] ~= nil then
        local conf = require("telescope.config").values
        conf.vimgrep_arguments = {
            "rg",
            "--no-binary",
            "--color=never",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--no-hidden",
        }
        for _, v in ipairs(option.rg) do
            table.insert(conf.vimgrep_arguments, v)
        end
    end
end

function M.telescope_ltaglist(opts)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local entry_display = require("telescope.pickers.entry_display")
    local previewers = require("telescope.previewers")
    local action_set = require("telescope.actions.set")
    local action_state = require("telescope.actions.state")

    opts = opts or {}

    local displayer = entry_display.create({
        separator = " | ",
        items = {
            { remaining = true },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        --vim.print(entry)
        return displayer({
            { entry.filename },
            { entry.text },
        })
    end

    local entry_maker = function(entry)
        local filename = vim.fn.bufname(entry.bufnr)
        local scode = entry.pattern
        scode = string.gsub(scode, [[^%^\V]], "")
        scode = string.gsub(scode, [[\%$]], "")
        return {
            value = entry,
            filename = filename,
            text = string.gsub(scode, [[^%s*]], ""),
            scode = scode,
            lnum = 1,
            col = 1,
            tag = entry.text,
            ordinal = filename .. ": " .. entry.text,
            display = make_display,
        }
    end

    local locations = vim.fn.getloclist(0)
    pickers.new(opts, {
        prompt_title = "Ltaglist",
        initial_mode = "normal",
        sorter = conf.generic_sorter(opts),
        previewer = previewers.ctags.new(opts),
        finder = finders.new_table({
            results = locations,
            entry_maker = entry_maker,
        }),
        attach_mappings = function()
            action_set.select:enhance({
                post = function()
                    local selection = action_state.get_selected_entry()

                    if selection.scode then
                        local scode = selection.scode
                        scode = string.gsub(scode, "[$]$", "")
                        scode = string.gsub(scode, [[\\]], [[\]])
                        scode = string.gsub(scode, [[\/]], [[/]])
                        scode = string.gsub(scode, "[*]", [[\*]])

                        vim.fn.search(scode, "w")
                        vim.cmd("norm! zz")
                    else
                        vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
                    end
                end,
            })
            return true
        end,
    }):find()
end

M.setup = { --{{{
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "fcying/telescope-ctags-outline.nvim" },
        { "nvim-telescope/telescope-live-grep-args.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = g.make },
        {
            "aznhe21/actions-preview.nvim",
            config = function()
                require("actions-preview").setup()
            end
        },
    },
    cmd = { "Telescope" },
    keys = {
        {
            "fc",
            function()
                require("telescope.builtin").colorscheme({
                    enable_preview = true,
                    colors = {
                        "rose-pine-dawn",
                        "everforest",
                        "solarized",
                        "tokyonight-day",
                    }
                })
            end,
            desc = "colorscheme"
        },
        --- @format disable
        { "ff", function() require("util").find_file() end, desc = "file", silent = true },
        { "fb", "<cmd>Telescope buffers<cr>",                       desc = "buffer" },
        { "fg", "<cmd>Telescope grep_string<cr>",                   desc = "string" },
        { "fg", "<cmd>Telescope grep_string<cr>", mode = "v",       desc = "string" },
        { "fh", "<cmd>Telescope help_tags<cr>",                     desc = "help" },
        { "fj", "<cmd>Telescope jumplist<cr>",                      desc = "jumplist" },
        { "fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "line" },
        { "fo", "<cmd>Telescope oldfiles<cr>",                      desc = "mru" },
        { "fm", "<cmd>Telescope marks<cr>",                         desc = "marks" },
        { "fn", "<cmd>lua Snacks.notifier.show_history({})<cr>",    desc = "notify" },
        { "fr", "<cmd>Telescope resume<cr>",                        desc = "resume" },
        { "ft", "<cmd>Telescope tags<cr>",                          desc = "tag" },
        { "f/", function() require("util").live_grep() end, mode = {"n", "x"},      desc = "live grep" },
        { "go", "<cmd>Telescope ctags_outline outline<CR>",         desc = "outline" },
        { "gO", "<cmd>Telescope ctags_outline outline buf=all<CR>", desc = "all buf outline" },
    },
    config = function()
        --vim.keymap.set("n", "f/", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
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
                    ctags = { "ctags", "--options=" .. g.config_dir .. "/etc/ctags" },
                    ft_opt = {
                        c = "--c-kinds=f",
                        cpp = "--c++-kinds=f --language-force=C++",
                        vim = "--vim-kinds=fk",
                        sh = "--sh-kinds=fk",
                        zsh = "--sh-kinds=fk",
                        lua = "--lua-kinds=fk",
                    },
                    --sorting_strategy = "ascending",
                },
            },
        })
        -- require("telescope").load_extension("notify")
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("ctags_outline")
        require("telescope").load_extension("live_grep_args")
        M.telescope_update_ignore()
    end,
}

return M
