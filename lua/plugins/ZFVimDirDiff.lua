return {
    "ZSaberLv0/ZFVimDirDiff",
    cmd = "ZFDirDiff",
    dependencies = "ZSaberLv0/ZFVimJob",
    init = function()
        vim.g.ZFJobVerboseLogEnable = 0
        vim.g.ZFDirDiffUI_showSameFile = 1
    end,
}
