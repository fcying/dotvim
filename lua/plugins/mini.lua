return {
    {
        "echasnovski/mini.bufremove",
        keys = { { "<leader>q", function() require("mini.bufremove").delete() end, desc = "Quit Buffer" } },
        config = function()
            require("mini.bufremove").setup()
            -- api.nvim_create_user_command("Bclose", "Bdelete", { bang = true })
        end
    },
    {
        "echasnovski/mini.surround",
        opts = {},
    },
}
