return {
    "fcying/just.nvim",
    cmd = { "JustSelect", "Just", "JustStop", "JustCreateTemplate" },
    keys = {
        { "<leader>rs", "<cmd>JustSelect<CR>", desc = "JustSelect" },
        { "<leader>rj", "<cmd>Just<CR>", desc = "Just" },
        { "<leader>rb", "<cmd>Just build<CR>", desc = "Just build" },
        { "<leader>rr", "<cmd>Just run " .. vim.fn.expand("%:p") .. "<CR>", desc = "Just run file" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim", -- async jobs
        "j-hui/fidget.nvim",     -- task progress (optional)
    },
    config = function()
        require("just").setup({
            open_qf_on_error = false,
            open_qf_on_start = true,
            close_qf_on_success = false,
            post_run = function(ret)
                if Option.just_post_run then
                    return Option.just_post_run(ret)
                end
                return nil
            end,
            global_justfile = vim.g.config_dir .. "/etc/justfile",
            justfile_name = ".justfile",
            justfile_template = [[
# https://just.systems
set unstable
set export
set shell := ["nu", "-c"]
set script-interpreter := ["nu"]

[script]
default:
    just --list

[script]
build:
    echo "Building project..."
]],
        })
    end
}
