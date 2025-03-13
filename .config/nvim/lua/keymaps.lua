vim.keymap.set("n", "<leader>q", ":q!<CR>", {noremap=false, silent = true })
vim.keymap.set({'n', 'v'}, "<C-S-c>", '"+y', {noremap=false, silent = true })
vim.keymap.set({'n', 'v'}, "<C-c>", '"+y', {noremap=false, silent = true })

vim.keymap.set({'n', 'v'}, '<C-s>', '<Esc>:w<CR>')
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a')

vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set('n', 'tq', '<Esc>:bdelete<CR>')
vim.keymap.set('n', 'tk', '<Esc>:bnext<CR>')
vim.keymap.set('n', 'tj', '<Esc>:bprev<CR>')

vim.keymap.set('i', "jj", "<ESC>", { desc = "Exit insert mode with jj" })

vim.keymap.set({'n', 'v', 'i', 'c'}, "<PageUp>", "<C-u>", { desc = "Scroll up half a page" })
vim.keymap.set({'n', 'v', 'i', 'c'}, "<PageDown>", "<C-d>", { desc = "Scroll down half a page" })


vim.keymap.set('n', '<leader><Del>', "<Esc>:execute 'silent !rm ' . expand('%') | bdelete<CR>")
