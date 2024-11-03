local opts = {
    icons = { mappings = false },
    delay = function(ctx)
        return ctx.plugin and 0 or 200
    end,
    plugins = {
        presets = {
            g = true,
            z = true,
        }
    },
    -- Start hidden and wait for a key to be pressed before showing the popup
    -- Only used by enabled xo mapping modes.
    ---@param ctx { mode: string, operator: string }
    defer = function(ctx)
        return ctx.mode == "V" or ctx.mode == "<C-V>"
    end,
    replace = {
        desc = {
            { "<Plug>%(?(.*)%)?", "%1" },
            { "^%+", "" },
            { "<[cC]md>", "" },
            { "<[cC][rR]>", "" },
            { "<[sS]ilent>", "" },
            { "^lua%s+", "" },
            { "^call%s+", "" },
            { "^:%s*", "" },
        },
    },
}
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup(opts)
        wk.add({
            { "<leader>c", group = "cd ..." },
            { "<leader>d", group = "delete ..." },
            { "<leader>e", group = "edit ..." },
            { "<leader>l", group = "lsp" },
            { "<leader>m", group = "mark" },
            { "<leader>s", group = "sandwich" },
            { "<leader>p", group = "plugin" },
            { "<leader>s", group = "surround" },
            { "<leader>t", group = "tab" },
            { "<leader>u", group = "util" },
            { "<leader>w", group = "window" },
            { "<leader>um", desc = "print current mode" },
            { "<leader>sn", desc = "noice" },
        })
    end
}
