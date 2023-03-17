local g, opt, fn, api = vim.g, vim.opt, vim.fn, vim.api

opt.autochdir = false
opt.autoread = true
opt.autowrite = false
opt.backup = false
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.cinkeys = opt.cinkeys - "0#"
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.completeopt = "menu,menuone,noselect,noinsert"
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs

opt.fileencodings = "ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,euc-kr,latin1"
opt.formatoptions = opt.formatoptions + "mM" - "o"
--stop auto insert comment, set FileType can't work
api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    group = api.nvim_create_augroup("set_fo", { clear = true }),
    callback = function()
        vim.opt_local.formatoptions = vim.opt_local.formatoptions - "o"
    end,
})

if g.has_rg == 1 then
    opt.grepformat = "%f:%l:%c:%m"
    opt.grepprg = "rg --vimgrep"
end

opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 2
opt.list = false -- Show some invisible characters (tabs...
opt.mouse = "a"
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = false
opt.scrolloff = 3
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4
opt.shortmess:append({ W = false, I = false, c = true })
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
opt.undodir =  g.cache_dir .. "/undodir_nvim"
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "onemore" -- onemore all
opt.visualbell = false
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
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

if fn.has("nvim-0.9.0") == 1 then
    opt.splitkeep = "screen"
    opt.shortmess:append({ C = true })
end
