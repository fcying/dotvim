return {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
        render = function(props)
            local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
            local filename = bufname
            local modified = vim.bo[props.buf].modified
            return {
                filename,
                modified and { " *" } or "",
            }
        end,
        highlight = {
            groups = {
                InclineNormal = {
                    default = true,
                    group = "Title"
                },
                InclineNormalNC = {
                    default = true,
                    group = "NormalFloat"
                }
            }
        },
        window = {
            placement = {
                horizontal = "right",
                vertical = "top"
            },
            width = "fit",
            winhighlight = {
                active = {
                    EndOfBuffer = "None",
                    Normal = "InclineNormal",
                    Search = "None"
                },
                inactive = {
                    EndOfBuffer = "None",
                    Normal = "InclineNormalNC",
                    Search = "None"
                }
            },
        },
    }
}
