vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require('plugins')

require('options')

vim.g.maplocalleader = ' ,'

vim.cmd([[

    syntax on
    filetype plugin indent on

    augroup FileTypeOptions
        autocmd!
        autocmd BufNewFile,BufRead *.sasm setfiletype asm
        autocmd BufNewFile,BufRead *.conf setfiletype conf
        autocmd BufNewFile,BufRead *.bf setfiletype text
        autocmd FileType asm set tabstop=24 shiftwidth=24 softtabstop=24
    augroup END

    augroup AutoPairOptions
        autocmd!
        autocmd FileType tex let AutoPairs["`"] = "'"
        autocmd FileType tex let AutoPairs["``"] = "\""
    augroup END

    augroup ZshHighlighting
        autocmd!
        autocmd BufNewFile,BufRead .zalias setfiletype zsh
        autocmd BufNewFile,BufRead .zfunctions setfiletype zsh
        autocmd BufNewFile,BufRead .zkeys setfiletype zsh
    augroup END

    augroup RunCode
        autocmd!
        autocmd BufNewFile,BufRead *.cpp,*.c,*.py,*.bf,*.asm
                \ noremap <space><space>r :!runcode.sh % <CR>
    augroup END

]])

require('keys')
