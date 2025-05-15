return {
    "Mythos-404/xmake.nvim",
    -- only use lua library
    lazy = true,
    opts = {
        on_save = {
            reload_project_info = false,
            lsp_compile_commands = { enable = false },
        },
    }
}
