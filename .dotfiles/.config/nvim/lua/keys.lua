local key_opts = {noremap = true, silent = true}

local function imap(key, cmd)
    vim.keymap.set('i', key, cmd, key_opts)
end

local function nmap(key, cmd)
    vim.keymap.set('n', key, cmd, key_opts)
end

-- imap('(',       "()<Esc>i")
-- imap('[',       "[]<Esc>i")
-- imap('{',       "{}<Esc>i")
-- imap("''",      "''<Esc>i")
-- imap('""',      '""<Esc>i')
-- imap("{<cr>",   "{<cr>}<Esc>O")
-- imap("{<Space>",   "{  }<Esc>hi")
imap("-[",      "-[[<Esc>a")
imap("-]",      "-]]<Esc>a")

-- vim.keymap.set('i', "jj", "<Esc>", key_opts)
nmap("zz", ":nohl<CR>")
nmap("<Space>wr", ":set wrap<CR>")

-- Telescope
nmap("<Space>/", ":Telescope live_grep <CR>")
nmap("<Space><Space>o", ":lua require'telescope.builtin'.oldfiles{}<CR>")
nmap("<Space>'", ":Telescope marks<CR>")
nmap("<Space>o", ":Telescope jumplist<CR>")

-- Oil.nvim
nmap("-", "<CMD>Oil<CR>")
nmap("<space>q", ":bdel<CR>")

-- Neovim terminal
nmap("<space>tr", ":split term://zsh || resize -5<CR><CR>i")

-- diagnostics
nmap("g?", ":lua vim.diagnostic.open_float()<CR>")
