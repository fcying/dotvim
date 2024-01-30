local util = require("util")
local map = util.map

map("n", "<leader>evc", ":execute 'e '  . g:config_dir<CR>")
map("n", "<leader>evl", ":execute 'e '  . g:file_vimrc_local<CR>")
map("n", "<leader>evp", require("project_config").edit_config)

-- fast ident {{{
map("n", "<", "<<")
map("x", "<", "<gv")
map("n", ">", ">>")
map("x", ">", ">gv|")

-- remap q Q {{{
map("n", "gQ", "Q")
map("n", "Q", "q")
map("n", "q", "<nop>")

-- goto def {{{
map("n", "g<c-]>", "<c-]>")
map("v", "g<c-]>", "<c-]>")
map("n", "<c-]>", function() util.go2def(vim.fn.expand("<cword>"), {mode="ltag"}) end)
map("v", "<c-]>", function() util.go2def(util.get_visual_selection(), {mode="ltag"}) end)
map("n", "gd", function() util.go2def(vim.fn.expand("<cword>"), {mode="lsp"}) end)

-- set working directory to the current file {{{
map("n", "<leader>cdt", ":tcd %:p:h<CR>:pwd<CR>", { desc = "set working directory for current tab" })
map("n", "<leader>cda", ":cd %:p:h<CR>:pwd<CR>", { desc = "set working directory" })

-- fast save ctrl-s {{{
map("n", "<C-s>", ":update<CR>")
map("v", "<C-s>", ":<C-u>update<CR>")
map("c", "<C-s>", "<C-u>update<CR>")
map("i", "<C-s>", "<C-o>:update<CR>")

-- auto pairs {{{
vim.cmd([[
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
]])
map("i", "{<CR>", "{<CR>}<c-o><s-o>")
map("i", "}", "<c-r>=ClosePair('}')<CR>")

-- save with sudo;  use vim-eunuch instead {{{
--nnoremap <leader>ws :w !sudo tee %<CR>

-- insert mode emacs {{{
map("i", "<C-a>", "<home>")
map("i", "<C-e>", "<end>")

-- cmd fast move {{{
map("c", "<C-h>", "<left>")
map("c", "<C-j>", "<down>")
map("c", "<C-k>", "<up>")
map("c", "<C-l>", "<right>")
map("c", "<C-a>", "<home>")
map("c", "<C-e>", "<end>")
map("c", "<C-f>", "<c-d>")
map("c", "<C-b>", "<left>")
map("c", "<C-d>", "<del>")
map("c", "<C-_>", "<c-k>")

-- cmd history search {{{
map("c", "<c-p>", function()
    return vim.fn.pumvisible() == 1 and "<c-p>" or "<up>"
end, { expr = true, silent = false })
map("c", "<c-n>", function()
    return vim.fn.pumvisible() == 1 and "<c-n>" or "<down>"
end, { expr = true, silent = false })

-- paste without overwrite register {{{
map("x", "p", '"_dP')

-- Start new line {{{
map("i", "<S-Return>", "<C-o>o")

-- delete space, ^M, ansi escape codes {{{
map("n", "<leader>ds", ":%s/\\s\\+$//g<CR>:noh<CR>", { desc = "trim trailing space" })
map("n", "<leader>dm", ":%s/\\r$//g<CR>:noh<CR>", { desc = "delete ^M" })
map("n", "<leader>da", ":%s/\\%x1b\\[[0-9;]*m//g<CR>:noh<CR>", { desc = "delete ansi escape codes" })

-- tab {{{
vim.cmd([[
function! s:tab_moveleft()
    let l:tabnr = tabpagenr() - 2
    if l:tabnr >= 0
        exec 'tabmove '.l:tabnr
    endif
endfunc
function! s:tab_moveright()
    let l:tabnr = tabpagenr() + 1
    if l:tabnr <= tabpagenr('$')
        exec 'tabmove '.l:tabnr
    endif
endfunc
command! -nargs=0 TabMoveRight call s:tab_moveright()
command! -nargs=0 TabMoveLeft call s:tab_moveleft()
noremap <silent> <leader>tc :tabnew<cr>
noremap <silent> <leader>tq :tabclose<cr>
noremap <silent> <leader>tn :tabnext<cr>
noremap <silent> <leader>tp :tabprev<cr>
noremap <silent> <leader>to :tabonly<cr>
noremap <silent><s-tab> :tabnext<CR>
inoremap <silent><s-tab> <ESC>:tabnext<CR>
noremap <silent><leader>1 :tabn 1<cr>
noremap <silent><leader>2 :tabn 2<cr>
noremap <silent><leader>3 :tabn 3<cr>
noremap <silent><leader>4 :tabn 4<cr>
noremap <silent><leader>5 :tabn 5<cr>
noremap <silent><leader>6 :tabn 6<cr>
noremap <silent><leader>7 :tabn 7<cr>
noremap <silent><leader>8 :tabn 8<cr>
noremap <silent><leader>9 :tabn 9<cr>
noremap <silent><leader>0 :tabn 10<cr>
]])


map("n", "<F2>", ":set number! number?<CR>")
map("n", "<F3>", ":set list! list?<CR>")
map("n", "<F4>", ":set wrap! wrap?<CR>")
map("n", "<F6>", ":exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>")

-- set paste mode, disbale when leaving insert mode
vim.opt.pastetoggle = "<F5>"
vim.cmd([[ autocmd myau InsertLeave * set nopaste ]])

