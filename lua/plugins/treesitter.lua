return
{
    {
        "Badhi/nvim-treesitter-cpp-tools",
        -- dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "c", "cpp" },
        opts = {
            preview = {
                quit = "q",
                accept = "<tab>"
            },
            header_extension = "h",
            source_extension = "cpp",
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- event = "VeryLazy",
        cmd = {
            "TSBufDisable",
            "TSBufEnable",
            "TSBufToggle",
            "TSDisable",
            "TSEnable",
            "TSToggle",
            "TSInstall",
            "TSInstallInfo",
            "TSInstallSync",
            "TSModuleInfo",
            "TSUninstall",
            "TSUpdate",
            "TSUpdateSync",
        },
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
        config = function()
            local parser_install_dir = vim.g.runtime_dir .. "/parsers"
            vim.opt.runtimepath:prepend(parser_install_dir)
            require("nvim-treesitter.configs").setup({
                parser_install_dir = parser_install_dir,
                ensure_installed = {
                    "vim", "vimdoc", "lua", "query", "comment",
                    "cpp", "typescript", "vue"
                },
                sync_install = #vim.api.nvim_list_uis() == 0,
                auto_install = false,
                ignore_install = {},
                matchup = { enable = true },
                highlight = {
                    enable = true,
                    --additional_vim_regex_highlighting = true,
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end

                        local hl_disable = { "help" }
                        if vim.tbl_contains(hl_disable, lang) then
                            return true
                        end
                        return false
                    end,
                },
                -- FIXME: can't use in c comment
                -- incremental_selection = {
                --     enable = true,
                --     keymaps = {
                --         node_incremental = "v",
                --         node_decremental = "V",
                --         scope_incremental = "<leader><C-v>",
                --     },
                --     disable = function(lang, _)
                --         local enable = { "c", "cpp", "lua" }
                --         if vim.tbl_contains(enable, lang) then
                --             return false
                --         end
                --         return true
                --     end,
                -- },
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            ["ab"] = { query = "@block.outer", desc = "around block" },
                            ["ib"] = { query = "@block.inner", desc = "inside block" },
                            ["ac"] = { query = "@class.outer", desc = "around class" },
                            ["ic"] = { query = "@class.inner", desc = "inside class" },
                            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
                            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
                            ["af"] = { query = "@function.outer", desc = "around function " },
                            ["if"] = { query = "@function.inner", desc = "inside function " },
                            ["al"] = { query = "@loop.outer", desc = "around loop" },
                            ["il"] = { query = "@loop.inner", desc = "inside loop" },
                            ["ap"] = { query = "@parameter.outer", desc = "around parameter" },
                            ["ip"] = { query = "@parameter.inner", desc = "inside parameter" },
                        },
                        include_surrounding_whitespace = false,
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]b"] = { query = "@block.outer", desc = "Next block start" },
                            ["]f"] = { query = "@function.outer", desc = "Next function start" },
                            ["]p"] = { query = "@parameter.inner", desc = "Next parameter start" },
                            ["]c"] = { query = "@class.outer", desc = "Next class start" },
                            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
                            ["]]"] = { query = "@function.outer", desc = "Next function start" },
                        },
                        goto_next_end = {
                            ["]B"] = { query = "@block.outer", desc = "Next block end" },
                            ["]F"] = { query = "@function.outer", desc = "Next function end" },
                            ["]P"] = { query = "@parameter.inner", desc = "Next parameter end" },
                            ["]C"] = { query = "@class.outer", desc = "Next class end" },
                        },
                        goto_previous_start = {
                            ["[b"] = { query = "@block.outer", desc = "Previous block start" },
                            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                            ["[p"] = { query = "@parameter.inner", desc = "Previous parameter start" },
                            ["[c"] = { query = "@class.outer", desc = "Previous class start" },
                            ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
                            ["[["] = { query = "@function.outer", desc = "Previous function start" },
                        },
                        goto_previous_end = {
                            ["[B"] = { query = "@block.outer", desc = "Previous block end" },
                            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
                            ["[P"] = { query = "@parameter.inner", desc = "Previous parameter end" },
                        },
                        goto_next = {
                            ["]w"] = "@conditional.outer",
                        },
                        goto_previous = {
                            ["[w"] = "@conditional.outer",
                        }
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            [">B"] = { query = "@block.outer", desc = "Swap next block" },
                            [">F"] = { query = "@function.outer", desc = "Swap next function" },
                            [">P"] = { query = "@parameter.inner", desc = "Swap next parameter" },
                        },
                        swap_previous = {
                            ["<B"] = { query = "@block.outer", desc = "Swap previous block" },
                            ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
                            ["<P"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
                        },
                    },
                }
            })
        end
    },
}
