local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>q", ":q!<CR>", opts)
vim.keymap.set({ 'n', 'v' }, "<C-S-c>", '"+y', opts)
vim.keymap.set({ 'n', 'v' }, "<C-c>", '"+y', opts)

vim.keymap.set({ 'n', 'v' }, '<C-s>', '<Esc>:w<CR>')
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a')

vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

vim.keymap.set('n', 'tq', '<Esc>:bdelete<CR>')
vim.keymap.set('n', 'tk', '<Esc>:bnext<CR>')
vim.keymap.set('n', 'tj', '<Esc>:bprev<CR>')

vim.keymap.set('i', "jj", "<ESC>", { desc = "Exit insert mode with jj" })

vim.keymap.set({ 'n', 'v', 'i', 'c' }, "<PageUp>", "<C-u>zz", { desc = "Scroll up half a page" })
vim.keymap.set({ 'n', 'v', 'i', 'c' }, "<PageDown>", "<C-d>zz", { desc = "Scroll down half a page" })

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv",
	{ desc = "moves lines down in visual selection", noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv",
	{ desc = "moves lines up in visual selection", noremap = true, silent = true })

vim.keymap.set('n', '<leader><Del>', "<Esc>:execute 'silent !rm ' . expand('%') | bdelete<CR>")

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "x", '"_x', opts)

vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "x", '"_x', opts)

vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word cursor is on globally" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

vim.keymap.set("n", "<leader>.", "<C-w>v", { desc = "Split window vertically" })
-- split window vertically
vim.keymap.set("n", "<leader>,", "<C-w>s", { desc = "Split window horizontally" })
