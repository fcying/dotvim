return {
    "terryma/vim-expand-region",
    keys = {
        { "v", mode = { "x" }, "<Plug>(expand_region_expand)", desc = "expand_region_expand" },
        { "V", mode = { "x" }, "<Plug>(expand_region_shrink)", desc = "expand_region_shrink" },
    },
    init = function()
        vim.cmd([[
            let g:expand_region_text_objects = {
                    \ 'iw'  :0,
                    \ 'iW'  :0,
                    \ 'i"'  :0,
                    \ 'i''' :0,
                    \ 'i]'  :1,
                    \ 'ib'  :1,
                    \ 'iB'  :1,
                    \ 'il'  :1,
                    \ 'ii'  :1,
                    \ 'ip'  :0,
                    \ 'ie'  :0,
                    \ }
            ]])
    end
}
