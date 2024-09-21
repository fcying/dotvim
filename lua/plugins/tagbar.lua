return {
    "preservim/tagbar",
    cmd = "TagbarToggle",
    keys = {
        { "<leader>wt", "<cmd>TagbarToggle<CR>", desc = "TagbarToggle" },
        { "<F11>", "<cmd>TagbarToggle<CR>", desc = "TagbarToggle" },
    },
    config = function()
        vim.g.tagbar_width = 32
        vim.g.tagbar_compact = 1
        vim.g.tagbar_type_vim = {
            ctagstype = "vim",
            kinds = {
                "p:plugin_setting",
                "f:functions",
            }
        }
        vim.g.tagbar_type_sh = {
            ctagstype = "sh",
            kinds = {
                "i:if_condition",
                "f:functions",
            }
        }
    end
}
