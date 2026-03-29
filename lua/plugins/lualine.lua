return {
    "nvim-lualine/lualine.nvim",
    event = "ColorScheme",
    config = function()
        local status = require("config.statusline")
        local theme = "auto"
        require("lualine").setup({
            tabline = {},
            extensions = {},
            options = {
                --globalstatus = true,
                always_divide_middle = true,
                component_separators = {
                    left = "|",
                    right = "|",
                },
                disabled_filetypes = {},
                icons_enabled = false,
                section_separators = {
                    left = "",
                    right = "",
                },
                theme = theme,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { status.git_status, "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = {
                    --status.search,
                    --status.macro_recording,
                    "fileformat",
                    status.fileencoding,
                    "filetype",
                    status.indent,
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        })
    end
}
