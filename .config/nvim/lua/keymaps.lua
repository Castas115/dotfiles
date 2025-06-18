local keymap = vim.keymap
local opts = { noremap = true, silent = true }


keymap.set({ "n", "x" }, ":", ";")
keymap.set({ "n", "x" }, ";", ":")

keymap.set("n", "<leader>q", ":q!<CR>", opts)
keymap.set("n", "<M-q>", ":qa!<CR>", opts)
keymap.set({ 'n', 'v' }, "<C-S-c>", '"+y', opts)
keymap.set({ 'n', 'v' }, "<C-c>", '"+y', opts)

keymap.set({ 'n', 'v' }, '<C-s>', '<Esc>:w<CR>')
keymap.set('i', '<C-s>', '<Esc>:w<CR>a')

keymap.set('n', '<C-h>', '<C-w>h', opts)
keymap.set('n', '<C-j>', '<C-w>j', opts)
keymap.set('n', '<C-k>', '<C-w>k', opts)
keymap.set('n', '<C-l>', '<C-w>l', opts)

vim.api.nvim_set_keymap('n', '<A-j>', '10jzz', opts)
vim.api.nvim_set_keymap('n', '<A-k>', '10kzz', opts)

vim.api.nvim_set_keymap('n', '<A-S-h>', ':vertical resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<A-S-j>', ':resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<A-S-k>', ':resize +2<CR>', opts)
vim.api.nvim_set_keymap('n', '<A-S-l>', ':vertical resize +2<CR>', opts)

keymap.set('n', 'tq', '<Esc>:bdelete<CR>')
keymap.set('n', 'tk', '<Esc>:bnext<CR>')
keymap.set('n', 'tj', '<Esc>:bprev<CR>')

keymap.set('i', "jj", "<ESC>", { desc = "Exit insert mode with jj" })

keymap.set({ 'n', 'v', 'i', 'c' }, "<PageUp>", "<C-u>zz", { desc = "Scroll up half a page" })
keymap.set({ 'n', 'v', 'i', 'c' }, "<PageDown>", "<C-d>zz", { desc = "Scroll down half a page" })

keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

keymap.set("v", "J", ":m '>+1<CR>gv=gv",
	{ desc = "moves lines down in visual selection", noremap = true, silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv",
	{ desc = "moves lines up in visual selection", noremap = true, silent = true })

keymap.set('n', '<leader><A-Del>', "<Esc>:execute 'silent !rm ' . expand('%') | bdelete<CR>")

keymap.set({ "n", "v" }, "<A-d>", [["_d]])
keymap.set("n", "<A-x>", '"_x', opts)

vim.keymap.set("v", "<A-s>", [[y:<C-u>%s/<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]],
    { desc = "Replace visually selected text globally" })
keymap.set("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word cursor is on globally" })

keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

keymap.set("n", "<leader>.", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>,", "<C-w>s", { desc = "Split window horizontally" })
