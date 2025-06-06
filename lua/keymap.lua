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
map("n", "Q", "q")
map("n", "q", "<nop>")

-- esc clear hl {{{
map("", "<esc>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    if vim.v.hlsearch == 1 then
        vim.cmd("noh")
    end
    -- require("notify").dismiss({})
end)

-- cmd-line window dd {{{
vim.api.nvim_create_autocmd({ "CmdwinEnter" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("cmd_line", { clear = true }),
    callback = function(event)
        ---@diagnostic disable-next-line
        local bufname = vim.fn.bufname("%")
        if vim.o.buftype == "nofile" and bufname == "[Command Line]" then
            map("n", "dd", function()
                local win_type = vim.fn.getcmdwintype()
                local line = vim.fn.line(".")
                vim.api.nvim_del_current_line()
                vim.fn.histdel(win_type, line)
                vim.cmd("wshada!")
                vim.cmd("rshada!")
            end, { buffer = event.buf })
        end
    end,
})

-- goto def {{{
map("n", "g<c-]>", "<c-]>")
map("v", "g<c-]>", "<c-]>")
map("n", "<c-]>", function() util.go2def(vim.fn.expand("<cword>"), { mode = "ltag" }) end)
map("v", "<c-]>", function() util.go2def(util.get_visual_selection(), { mode = "ltag" }) end)
map("n", "gd", function() util.go2def(vim.fn.expand("<cword>"), { mode = "lsp" }) end)
map("v", "gd", function() util.go2def(util.get_visual_selection(), { mode = "lsp" }) end)

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

-- insert mode emacs {{{
map("i", "<C-a>", "<home>")
map("i", "<C-e>", "<end>")

-- window fast move {{{
-- map("n", "<C-h>", [[<Cmd>wincmd h<CR>]])
-- map("n", "<C-j>", [[<Cmd>wincmd j<CR>]])
-- map("n", "<C-k>", [[<Cmd>wincmd k<CR>]])
-- map("n", "<C-l>", [[<Cmd>wincmd l<CR>]])

-- cmd history search {{{
map("c", "<c-k>", function()
    return vim.fn.pumvisible() == 1 and "<c-p>" or "<up>"
end, { expr = true, silent = false })
map("c", "<c-j>", function()
    return vim.fn.pumvisible() == 1 and "<c-n>" or "<down>"
end, { expr = true, silent = false })


-- paste without overwrite register {{{
map("x", "p", function()
    -- virtual block
    if vim.api.nvim_get_mode().mode == "\22" then
        vim.api.nvim_feedkeys("p", "n", true)
    else
        vim.api.nvim_feedkeys('"_dP', "n", true)
    end
end)

-- print current mode {{{
map({ "x", "n" }, "<leader>um", function()
    vim.print(vim.api.nvim_get_mode())
end)

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

-- quickfix {{{
local function jump_to_error(forward)
    local qflist = vim.fn.getqflist()
    local current_idx = vim.fn.getqflist({ idx = 0 }).idx
    local step = forward and 1 or -1

    local i = current_idx + step
    while i >= 1 and i <= #qflist do
        local item = qflist[i]
        if item.type ~= "I" and item.valid == 1 then
            vim.cmd(i .. "cc")
            return
        end
        i = i + step
    end
    vim.notify("No more items", vim.log.levels.INFO)
end
map("n", "]q", function() jump_to_error(true) end, { silent = true })
map("n", "[q", function() jump_to_error(false) end, { silent = true })

-- auto bottom and occupy the full width
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.cmd("wincmd J")
    end,
})

-- RemoveLsplog {{{
vim.api.nvim_create_user_command("RemoveLsplog", function()
    vim.fn.writefile({}, vim.lsp.get_log_path())
end, {})

vim.cmd([[ autocmd FileType qf wincmd J ]])
