return {
    "fcying/just.nvim",
    cmd = { "JustSelect", "Just", "JustStop", "JustCreateTemplate" },
    keys = {
        { "<leader>rs", "<cmd>JustSelect<CR>", desc = "JustSelect" },
        { "<leader>rj", "<cmd>Just<CR>", desc = "Just" },
        { "<leader>rb", "<cmd>Just build<CR>", desc = "Just build" },
        { "<leader>rr", "<cmd>Just release<CR>", desc = "Just release" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim", -- async jobs
        "j-hui/fidget.nvim",     -- task progress (optional)
    },
    config = function()
        require("just").setup({
            open_qf_on_error = true,
            open_qf_on_run = true,
            open_qf_on_any = true,
            post_run = function(ret)
                if Option.just_post_run then
                    return Option.just_post_run(ret)
                end
                return nil
            end,
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
