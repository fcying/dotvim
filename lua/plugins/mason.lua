local g = vim.g
local M = {}

function M.get_version(name)
    local fetch = require("mason-core.fetch")
    local ver = fetch("https://github.com/fcying/tools/releases/tag/tools").value
    if type(ver) ~= "string" then
        vim.notify("Unable to get latest " .. name .. " version.")
        return nil
    end

    if name == "clangd" then
        ver = string.match(ver, "<li>clangd (.-) last")
    elseif name == "lua-language-server" then
        ver = string.match(ver, "<li>luals (.-)</li>")
    elseif name == "autohotkey2-lsp" then
        ver = string.match(ver, "<li>autohotkey2%-lsp (.-)</li>")
    else
        ver = nil
    end

    --vim.notify("get " .. vim.inspect(name) .. " " .. vim.inspect(ver))
    return ver
end

function M.get_schema(ctx, url)
    local path = require("mason-core.path")
    local fetch = require "mason-core.fetch"
    local Result = require "mason-core.result"
    local out_file = "lsp.json"
    local share_file = path.concat { "mason-schemas", "lsp", ("%s.json"):format(ctx.package.name) }
    local json = fetch(url).value
    local schema = Result.pcall(vim.json.decode, json).value
    local configuration = schema.contributes and schema.contributes.configuration

    if configuration then
        ctx.fs:write_file(out_file, vim.json.encode(configuration) --[[@as string]])
        ctx.links.share[share_file] = out_file
    else
        vim.notify("Unable to find LSP entry in VSCode schema.")
    end
end

function M.setup()
    return {
        "fcying/mason.nvim",
        lazy = false,
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                install_root_dir = g.runtime_dir .. "/mason",
                --pip = {
                --    install_args = { "-i", "https://pypi.tuna.tsinghua.edu.cn/simple" },
                --},
                registries = {
                    "lua:registry",
                    "github:mason-org/mason-registry",
                },
            })

            local std = require("mason-core.managers.std")
            ---@diagnostic disable-next-line
            std.custom_check_outdated_primary_package = function(receipt, install_dir)
                local Result = require "mason-core.result"
                local source = receipt.primary_source
                if source.type ~= "custom" then
                    return Result.failure "Receipt does not have a primary source of type custom."
                end
                local ver = M.get_version(receipt.name)
                if ver ~= source.release and ver ~= nil then
                    return Result.success({
                        name = source.repo,
                        current_version = source.release,
                        latest_version = ver,
                    })
                end
            end
        end
    }
end

return M
