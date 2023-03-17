return {
    'lambdalisue/fern.vim',
    cmd = 'Fern',
    keys = {
        { "<leader>wf", "<cmd>Fern . -drawer -toggle -keep<CR>" },
        { "<leader>wl", "<cmd>Fern . -drawer -reveal=%<CR>" },
    },
    config = function()
        vim.api.nvim_create_autocmd({ 'FileType' }, {
            pattern = 'fern',
            group = vim.api.nvim_create_augroup('fern_init', { clear = true }),
            callback = function()
                vim.cmd([[
                    nmap <buffer><expr>
                          \ <Plug>(fern-my-open-or-expand-or-collapse)
                          \ fern#smart#leaf(
                          \   "\<Plug>(fern-action-open)",
                          \   "\<Plug>(fern-action-expand)",
                          \   "\<Plug>(fern-action-collapse)",
                          \ )
                    nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-or-expand-or-collapse)
                    nmap <buffer> <enter> <Plug>(fern-my-open-or-expand-or-collapse)
                    nmap <buffer> t <Plug>(fern-action-open:tabedit)
                    nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
                    nmap <buffer> i <Plug>(fern-action-open:split)
                    nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
                    nmap <buffer> s <Plug>(fern-action-open:vsplit)
                    nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p

                    nmap <buffer> E <Plug>(fern-action-enter)
                    nmap <buffer> u <Plug>(fern-action-leave)
                    nmap <buffer> r <Plug>(fern-action-reload)
                    nmap <buffer> d <Plug>(fern-action-remove)
                    nmap <buffer> q :<C-u>quit<CR>
                ]])
            end,
        })
    end
}
