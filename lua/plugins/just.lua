return {
    "fcying/just.nvim",
    cmd = { "JustSelect", "Just", "JustStop", "JustCreateTemplate" },
    keys = {
        { "<leader>rs", "<cmd>JustSelect<CR>", desc = "JustSelect" },
        { "<leader>rj", "<cmd>Just<CR>", desc = "Just" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",         -- async jobs
        "nvim-telescope/telescope.nvim", -- task picker (optional)
        "j-hui/fidget.nvim",             -- task progress (optional)
    },
    config = function()
        require("just").setup({
            open_qf_on_error = true,
            open_qf_on_run = true,
            open_qf_on_any = true,
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
