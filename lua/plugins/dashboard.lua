local opts = {
    theme = "doom",
    hide = { statusline = false },
    config = {
        header = require("ascii_logo").neovim1,
        center = {
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = "lua require('util').find_file()", desc = " Find file", icon = " ", key = "ff" },
            { action = "lua require('util').live_grep()", desc = " Find text", icon = " ", key = "f/" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "fm" },
            --{ action = "lua require('persistence').load()",     desc = " Restore Session", icon = " ", key = "s" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
            local version = vim.version().major .. "." .. vim.version().minor .. vim.version().patch
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "Neovim-" .. version .. " loaded " .. stats.loaded .. "/"
            .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
    },
}

for _, button in ipairs(opts.config.center) do
    button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
    button.key_format = "  %s"
end

return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    opts = opts,
}
