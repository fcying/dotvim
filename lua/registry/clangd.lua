local Pkg = require("mason-core.package")
local path = require("mason-core.path")
local std = require("mason-core.managers.std")
local m = require("plugins.mason")

return Pkg.new({
    name = "clangd",
    desc = [[clangd build with rpath]],
    homepage = "https://clangd.llvm.org",
    languages = { Pkg.Lang.C, Pkg.Lang["C++"] },
    categories = { Pkg.Cat.LSP },
    ---@async
    install = function(ctx)
        local ver = m.get_version(ctx.package.name)
        local file = "https://github.com/fcying/tools/releases/download/tools/clangd_linux_amd64.txz"
        std.download_file(file, "lsp.txz")
        std.untarxz("lsp.txz")

        ctx.receipt:with_primary_source({
            type = "custom",
            repo = "fcying/tools",
            file = file,
            release = ver,
        })
        m.get_schema(ctx, "https://raw.githubusercontent.com/clangd/vscode-clangd/master/package.json")

        ctx:link_bin(
            "clangd",
            path.concat({
                "clangd",
                "bin",
                "clangd",
            })
        )
    end,
})
