return {
    "MagicDuck/grug-far.nvim",
    keys = {
        {
            "<leader>fr",
            mode = { "n", "x" },
            function()
                require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
            end,
            desc = "far"
        },
    },
    opts = {
        engines = {
            ripgrep = {
                path = "rg",
                extraArgs = "--no-config",
                showReplaceDiff = true,
                placeholders = {
                    enabled = true,
                    search = "ex: foo   foo([a-z0-9]*)   fun\\(",
                    replacement = "ex: bar   ${1}_foo   $$MY_ENV_VAR ",
                    replacement_lua =
                    'ex: if vim.startsWith(match, "use") \\n then return "employ" .. match \\n else return match end',
                    filesFilter = "ex: *.lua   *.{css,js}   **/docs/*.md   (specify one per line)",
                    flags = "ex: --help --ignore-case (-i) --replace= (empty replace) --multiline (-U)",
                    paths = "ex: /foo/bar   ../   ./hello\\ world/   ./src/foo.lua",
                },
            },
        }
    },
}
