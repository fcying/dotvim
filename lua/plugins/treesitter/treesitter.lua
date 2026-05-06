return
{
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local parser_install_dir = vim.g.runtime_dir .. "/parsers"

        if not vim.g.treesitter_parser_compiler_patched then
            local vim_system = vim.system
            vim.system = function(cmd, opts, on_exit)
                if type(cmd) == "table" and cmd[1] == "tree-sitter" and cmd[2] == "build" then
                    opts = vim.tbl_extend("force", opts or {}, {
                        env = vim.tbl_extend("force", opts and opts.env or {}, {
                            CC = "gcc"
                        })
                    })
                end

                return vim_system(cmd, opts, on_exit)
            end
            vim.g.treesitter_parser_compiler_patched = true
        end

        vim.opt.runtimepath:prepend(parser_install_dir)
        require("nvim-treesitter").setup {
            install_dir = parser_install_dir
        }

        local ensure_installed = {
            "vim", "vimdoc", "lua", "query", "comment",
            "go", "python", "typescript", "vue"
        }
        if #vim.api.nvim_list_uis() == 0 then
            require("nvim-treesitter").install(ensure_installed):wait(300000)
        else
            require("nvim-treesitter").install(ensure_installed)
        end
    end
}
