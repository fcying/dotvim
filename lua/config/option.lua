local g, opt, fn = vim.g, vim.opt, vim.fn
local util = require("util")
local map = util.map

g.has_rg = fn.executable("rg")
g.has_go = fn.executable("go")

vim.api.nvim_create_augroup("myau", { clear = true })

if g.is_win then
    g.make = "mingw32-make"
else
    g.make = "make"
end

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- options {{{
opt.autochdir = false
opt.autoread = true
opt.autowrite = false
opt.backup = false
if g.osc52_auto_yank ~= 0 then
    opt.clipboard = "unnamedplus" -- Sync normal yank with system clipboard
end
opt.cinkeys = opt.cinkeys - "0#"
opt.cmdheight = 1
opt.confirm = false   -- Confirm to save changes before exiting modified buffer
opt.completeopt = "menu,menuone,noselect,noinsert"
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true  -- Use spaces instead of tabs
opt.jumpoptions = "stack"

opt.modeline = false
opt.bomb = false
opt.fileencodings = "ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,euc-kr,latin1"
opt.formatoptions = opt.formatoptions + "mM" - "o"
--stop auto insert comment, set FileType can't work
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "o" })
    end,
})

-- errorformat Keil {{{
-- FIXME: invalid %-  https://github.com/neovim/neovim/issues/29061
-- opt.errorformat:prepend("%-GBuild Time Elapsed:%m")
vim.cmd [[set errorformat^=%-GBuild\ Time\ Elapsed:%m,%-GBatch-Build\ summary:%m]]
vim.cmd [[set errorformat^=%I%f(%l):\ warning:\ L6329W:%m]]
-- xmake
vim.cmd [[set errorformat^=%Eerror:\ %f:%l:%c:\ error:\ %m]]
vim.cmd [[set errorformat^=%Eerror:\ %f:%l:\ error:\ %m]]

if g.has_rg == 1 then
    opt.grepformat = "%f:%l:%c:%m"
    opt.grepprg = "rg --vimgrep"
end

opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 2
opt.list = false           -- Show some invisible characters (tabs...
opt.mouse = "a"
opt.number = true          -- Print line number
opt.pumblend = 10          -- Popup blend
opt.pumheight = 10         -- Maximum number of entries in a popup
opt.relativenumber = false
opt.scrolloff = 3
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4
-- opt.shortmess:append("I") -- intro message
opt.shortmess:append("c")
opt.shortmess:append("C")
opt.shortmess:append("s")
--opt.shortmess:append("S")
opt.showmode = false
opt.signcolumn = "auto"
opt.smartcase = true
opt.smartindent = true
opt.swapfile = false
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 500
opt.ttimeoutlen = 80
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "onemore" -- onemore all
opt.visualbell = false
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = true
opt.whichwrap = opt.whichwrap + "<,>,[,],h,l"

-- foldmethod {{{
opt.foldmethod = "manual"
opt.foldenable = false

-- ignore file in search && complete {{{
opt.suffixes = ".bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class"
opt.wildignore = "*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib"
opt.wildignore = opt.wildignore + "*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex"
opt.wildignore = opt.wildignore + "*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz"
opt.wildignore = opt.wildignore + "*DS_Store*,*.ipch"
opt.wildignore = opt.wildignore + "*.gem"
opt.wildignore = opt.wildignore + "*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso"
opt.wildignore = opt.wildignore + "*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**"
opt.wildignore = opt.wildignore + "*/.nx/**,*.app,*.git,.git"
opt.wildignore = opt.wildignore + "*.wav,*.mp3,*.ogg,*.pcm"
opt.wildignore = opt.wildignore + "*.mht,*.suo,*.sdf,*.jnlp"
opt.wildignore = opt.wildignore + "*.chm,*.epub,*.pdf,*.mobi,*.ttf"
opt.wildignore = opt.wildignore + "*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc"
opt.wildignore = opt.wildignore + "*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps"
opt.wildignore = opt.wildignore + "*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu"
opt.wildignore = opt.wildignore + "*.gba,*.sfc,*.078,*.nds,*.smd,*.smc"
opt.wildignore = opt.wildignore + "*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android"

-- filetype {{{
vim.api.nvim_create_augroup("myft", { clear = true })
vim.cmd([[
autocmd myft BufNewFile,BufRead *.conf setl filetype=conf
autocmd myft BufNewFile,BufRead *.json setl filetype=jsonc
autocmd myft BufNewFile,BufRead *.tasks setl filetype=taskini
autocmd myft BufNewFile,BufRead syslog setl filetype=messages
autocmd myft BufNewFile,BufRead *shrc.local,rc.local setl filetype=sh
autocmd myft BufNewFile,BufRead gitconfig setl filetype=gitconfig

]])

-- close some filetypes with <q> {{{
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
    pattern = {
        "help",
        "lspinfo",
        "man",
        "notify",
        "PlenaryTestPopup",
        "qf",
        "query", -- :InspectTree
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "fugitive*",
        "flog*",
        "git",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        map("n", "q", "<cmd>close<cr>", { buffer = event.buf })
    end,
})

-- osc52 clip {{{
local function paste()
    if vim.g.is_wsl then
        local cmd
        if vim.fn.executable("win32yank.exe") == 1 then
            cmd = "win32yank.exe -o --lf"
        else
            cmd = 'powershell -NoProfile -Command "[Console]::Out.Write((Get-Clipboard -Raw))"'
        end
        local stdout = vim.fn.system(cmd)
        stdout = stdout:gsub("\r\n", "\n")
        local lines = vim.split(stdout, "\n", { plain = true })
        local regtype = "v" -- Default to characterwise (normal text)

        -- If the original text ends with a newline, it's a linewise copy (like yy)
        if stdout:sub(-1) == "\n" then
            regtype = "V"           -- Set to linewise so 'p' pastes on the next line
            if #lines > 1 and lines[#lines] == "" then
                table.remove(lines) -- Remove the empty element caused by the trailing split
            end
        end
        return { lines, regtype }
    else
        return {
            vim.split(vim.fn.getreg(""), "\n"),
            vim.fn.getregtype(""),
        }
    end
end

local osc52_copy_plus = require("vim.ui.clipboard.osc52").copy("+")
local osc52_copy_star = require("vim.ui.clipboard.osc52").copy("*")

vim.g.clipboard = {
    name = "osc52",
    copy = {
        ["+"] = osc52_copy_plus,
        ["*"] = osc52_copy_star,
    },
    paste = {
        ["+"] = paste,
        ["*"] = paste,
    },
}
