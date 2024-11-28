vim.opt.termguicolors = true
vim.opt.guifont = {'MesloLGS NF', ':h10'}
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.showtabline = 2
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
-- vim.opt.cmdheight = 0
vim.opt.foldmethod = "manual"
vim.opt.splitbelow = true
vim.opt.autochdir = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.relativenumber = true

if vim.g.neovide then
    vim.opt.guifont = {'MesloLGS NF:h11'}
end

vim.notify = require('notify')
