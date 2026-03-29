return
{
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local parser_install_dir = vim.g.runtime_dir .. "/parsers"
        vim.opt.runtimepath:prepend(parser_install_dir)
        require("nvim-treesitter").setup {
            install_dir = parser_install_dir
        }

        local ensure_installed = {
            "vim", "vimdoc", "lua", "query", "comment",
            "go", "python", "typescript", "vue"
        }
        if #vim.api.nvim_list_uis() == 0 then
            require("nvim-treesitter").install(ensure_installed)
        else
            require("nvim-treesitter").install(ensure_installed):wait(300000)
        end
    end
}
