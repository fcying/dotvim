return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    keys = {
        { "<leader>wf", "<cmd>NvimTreeToggle<CR>", desc = "file explorer" },
        { "<leader>wl", "<cmd>NvimTreeFindFile<CR>", desc = "file location" },
    },
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function()
        vim.api.nvim_create_autocmd("Colorscheme", {
            pattern = "*",
            group = vim.api.nvim_create_augroup("nvim_tree_color", { clear = true }),
            callback = function()
                local hl_group = vim.api.nvim_get_hl(0, { name = "Normal" })
                local guifg = hl_group.fg
                local guibg = hl_group.bg
                local cmd = "highlight NvimTreeNormal"
                if guifg then
                    cmd = cmd .. " guifg=" .. string.format("#%x", guifg)
                end
                if guibg then
                    cmd = cmd .. " guibg=" .. string.format("#%x", guibg)
                end
                if guifg or guibg then
                    vim.cmd(cmd)
                end
                -- vim.print(hl_group)
            end,
        })
        local function nvim_tree_attach(bufnr)
            local api = require "nvim-tree.api"

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            vim.keymap.del({ "n" }, "-", { buffer = bufnr })
            map("n", "u", api.tree.change_root_to_parent, opts("Up"))
            map("n", "r", api.fs.rename_full, opts("Rename: Full Path"))
        end
        require("nvim-tree").setup({
            on_attach = nvim_tree_attach,
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                        --picker = "default",
                        --picker = require("window-picker").pick_window,
                        picker = function()
                            local win_id = require("window-picker").pick_window({
                                show_no_windows_prompt = false,
                                filter_rules = {
                                    autoselect_one = true,
                                    include_current_win = false,
                                },
                            })
                            if win_id then
                                return win_id
                            else
                                require("nvim-tree.api").node.open.no_window_picker()
                                return nil
                            end
                        end,
                    }
                },
            },
        })
    end,
}
