return {
    "smoka7/hop.nvim",
    version = "*",
    keys = {
        {
            "s",
            mode = { "n" },
            function()
                local hop = require("hop")
                -- local directions = require("hop.hint").HintDirection
                -- hop.hint_char1({ direction = directions.AFTER_CURSOR })
                hop.hint_char1({})
            end,
            desc = "hop"
        },
    },
    config = function()
        require("hop").setup({
            keys = "etovxqpdygfblzhckisuran",
            match_mappings = { "zh", "zh_sc" },
        })
    end,
}
