local cmp_dictionary = function()
    local dict_path = vim.g.config_dir .. "/dict/"
    local dict = {
        ["*"] = { dict_path .. "dictionary" },
        ["xmake"] = { dict_path .. "xmake.dict" },
        ["go"] = { dict_path .. "go.dict" },
        ["cmake"] = { dict_path .. "cmake.dict" },
    }

    local function get_dict_path(file)
        local paths = {}
        if file:find(".*xmake.lua") then
            paths = dict.xmake
        else
            paths = dict[vim.bo.filetype] or {}
        end
        vim.list_extend(paths, dict["*"])
        --vim.print(paths)
        return paths
    end

    require("cmp_dictionary").setup({
        paths = get_dict_path(vim.fn.expand("%")),
        exact_length = 2,
        first_case_insensitive = false,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(ev)
            require("cmp_dictionary").setup({ paths = get_dict_path(ev.file) })
        end,
    })
end

return {
    "uga-rosa/cmp-dictionary",
    config = cmp_dictionary,
}
