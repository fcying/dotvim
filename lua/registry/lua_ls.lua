local Pkg = require("mason-core.package")
local path = require("mason-core.path")
local std = require("mason-core.managers.std")
local m = require("plugins.mason")

return Pkg.new({
    name = "lua-language-server",
    desc = [[Lua Language Server nightly build]],
    homepage = "https://github.com/LuaLS/lua-language-server",
    languages = { Pkg.Lang.Lua },
    categories = { Pkg.Cat.LSP },
    ---@async
    install = function(ctx)
        local ver = m.get_version(ctx.package.name)
        local file = "https://github.com/fcying/tools/releases/download/tools/lua-language-server.txz"
        std.download_file(file, "lsp.txz")
        std.untarxz("lsp.txz")

        ctx.receipt:with_primary_source({
            type = "custom",
            repo = "fcying/tools",
            file = file,
            release = ver,
        })
        m.get_schema(ctx, "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/package.json")

        ctx:link_bin(
            "lua-language-server",
            path.concat({
                "lua-language-server",
                "bin",
                "lua-language-server",
            })
        )
    end,
})
