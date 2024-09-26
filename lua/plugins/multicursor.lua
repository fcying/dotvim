return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")

        mc.setup()

        -- Add a cursor and jump to the next word under cursor.
        vim.keymap.set({ "n", "v" }, "<c-n>", function() mc.addCursor("*") end)

        -- Jump to the next word under cursor but do not add a cursor.
        vim.keymap.set({ "n", "v" }, "<c-s>", function() mc.skipCursor("*") end)

        -- -- Delete the main cursor.
        -- vim.keymap.set({ "n", "v" }, "<leader>x", mc.deleteCursor)

        vim.keymap.set("n", "<esc>", function()
            if mc.hasCursors() then
                mc.clearCursors()
            else
                if vim.v.hlsearch == 1 then
                    vim.cmd("noh")
                end
                require("notify").dismiss({})
            end
        end)

        -- Append/insert for each line of visual selections.
        -- vim.keymap.set("v", "I", mc.insertVisual)
        -- vim.keymap.set("v", "A", mc.appendVisual)

        -- Customize how cursors look.
        vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
        vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
}
