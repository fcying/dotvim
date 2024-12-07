return {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = function()
        -- TODO: one tab one term
        local float_opts = {
            border = "rounded",
        }
        local tig = require("toggleterm.terminal").Terminal:new({
            cmd = "tig",
            hidden = true,
            direction = "float",
            float_opts = float_opts,
            clear_env = true,
        })
        local toggle = function()
            if vim.bo.filetype == "toggleterm" then
                vim.cmd("ToggleTerm direction=float")
            else
                vim.cmd("ToggleTerm direction=float")
                vim.defer_fn(function()
                    if vim.fn.mode() == "n" then
                        vim.cmd("startinsert!")
                    end
                end, 10)
            end
        end

        return
        {
            { [[<c-\>]], toggle, mode = { "n", "t" }, desc = "Toggle Terminal" },
            { "`", toggle, mode = { "n", "t" }, desc = "Toggle Terminal" },
            { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "ToggleTerm" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "ToggleTerm float" },
            { "<leader>gt", function() tig:toggle() end, desc = "tig" },
        }
    end,
    config = function()
        require("toggleterm").setup({
            size = 20,
            clear_env = false,
            direction = "horizontal", --'vertical' | 'horizontal' | 'tab' | 'float'
            hide_numbers = true,
            shade_terminals = false,
            start_in_insert = true,
            insert_mappings = true,
            ---@param term Terminal
            on_create = function(term)
                if term.hidden then
                end
                vim.opt_local.foldcolumn = "0"
                vim.opt_local.signcolumn = "no"

                local opts = { buffer = 0 }
                vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
                -- vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
                -- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
                -- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
                -- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
            end,
        })
    end
}
