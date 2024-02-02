local Pkg = require("mason-core.package")
local _ = require("mason-core.functional")
local platform = require("mason-core.platform")
local github = require("mason-core.managers.github")
local path = require("mason-core.path")

local coalesce, when = _.coalesce, _.when

return Pkg.new({
    name = "clangd",
    desc = _.dedent([[
        custom clangd understands your C++ code and adds smart features to your editor: code completion, compile errors,
        go-to-definition and more.
    ]]),
    homepage = "https://clangd.llvm.org",
    languages = { Pkg.Lang.C, Pkg.Lang["C++"] },
    categories = { Pkg.Cat.LSP },
    ---@async
    install = function(ctx)
        local source
        local std = require("mason-core.managers.std")
        if platform.is.linux_x64 == true then
            local ver = require("plenary.curl").get("https://github.com/fcying/tools/releases/latest").body
            ver = "clangd-" .. string.match(ver, "clangd (.-) last")
            ctx.github_release_file = "https://github.com/fcying/tools/releases/download/" .. ver .. "/clangd_linux_amd64.txz"
            std.download_file(ctx.github_release_file, "clangd_linux_amd64.txz")
            std.untarxz("clangd_linux_amd64.txz")
            ctx.receipt:with_primary_source({
                type = "github_release_file",
                repo = "fcying/tools",
                file = ctx.github_release_file,
                release = ver,
            })
        else
            source = github.unzip_release_file({
                repo = "clangd/clangd",
                asset_file = function(release)
                    local target = coalesce(
                        when(platform.is.mac, "clangd-mac-%s.zip"),
                        when(platform.is.linux_x64, "clangd-linux-%s.zip"),
                        when(platform.is.win_x64, "clangd-windows-%s.zip")
                    )
                    return target and target:format(release)
                end,
            })
            source.with_receipt()
            ctx.fs:rename(("clangd_%s"):format(source.release), "clangd")
        end
        ctx:link_bin(
            "clangd",
            path.concat({
                "clangd",
                "bin",
                platform.is.win and "clangd.exe" or "clangd",
            })
        )
    end,
})
