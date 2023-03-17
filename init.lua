local g, fn = vim.g, vim.fn

g.config_dir = fn.fnamemodify(fn.resolve(fn.expand("<sfile>:p")), ":h")
vim.opt.rtp:prepend(g.config_dir)

require("config").init()
