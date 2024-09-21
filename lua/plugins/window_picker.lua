return {
    "s1n7ax/nvim-window-picker",
    keys = {
        {
            "-",
            function()
                local win_id = require("window-picker").pick_window()
                if win_id then
                    vim.api.nvim_set_current_win(win_id)
                end
            end,
            desc = "window picker"
        }
    },
    opts = {
        hint = "floating-big-letter",
        selection_chars = "abcdefghijk",
        show_prompt = false,
        filter_rules = {
            autoselect_one = true,
            include_current_win = true,
            bo = {
                filetype = { "incline" },
                -- buftype = { "terminal", "quickfix" },
            },
        },
    },
}
