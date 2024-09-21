return {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
        vim.cmd([[
                let g:VM_maps = {}
                let g:VM_maps['Find Under']         = '<C-n>'
                let g:VM_maps['Find Subword Under'] = '<C-n>'
                let g:VM_cmdheight = 1
            ]])
    end,
}
