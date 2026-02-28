local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<leader>q", ":q!<CR>", { noremap = true, silent = true, desc = "Quit without saving" })
keymap.set("n", "<M-q>", ":qa!<CR>", { noremap = true, silent = true, desc = "Quit all without saving" })
keymap.set({ 'n', 'v' }, "<C-S-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
keymap.set({ 'n', 'v' }, "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

keymap.set({ 'n', 'v' }, '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = "Save file" })
keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true, desc = "Save file" })

keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = "Move to left window" })
keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = "Move to bottom window" })
keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = "Move to top window" })
keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = "Move to right window" })

keymap.set({ 'n', 'v' }, "<A-j>", "10jzz", { noremap = true, silent = true, desc = "Scroll down 10 lines" })
keymap.set({ 'n', 'v' }, "<A-k>", "10kzz", { noremap = true, silent = true, desc = "Scroll up 10 lines" })
keymap.set({ 'n', 'v' }, "<PageUp>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll up half page" })
keymap.set({ 'n', 'v' }, "<PageDown>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll down half page" })

keymap.set('n', '<A-S-h>', ':vertical resize -4<CR>', { noremap = true, silent = true, desc = "Decrease width" })
keymap.set('n', '<A-S-j>', ':resize -2<CR>', { noremap = true, silent = true, desc = "Decrease height" })
keymap.set('n', '<A-S-k>', ':resize +2<CR>', { noremap = true, silent = true, desc = "Increase height" })
keymap.set('n', '<A-S-l>', ':vertical resize +4<CR>', { noremap = true, silent = true, desc = "Increase width" })

keymap.set('n', 'tq', '<Esc>:bdelete<CR>', { noremap = true, silent = true, desc = "Delete buffer" })
keymap.set('n', 'tk', '<Esc>:bnext<CR>', { noremap = true, silent = true, desc = "Next buffer" })
keymap.set('n', 'tj', '<Esc>:bprev<CR>', { noremap = true, silent = true, desc = "Previous buffer" })

keymap.set('n', 'tn', '<Esc>:tabnew<CR>', { noremap = true, silent = true, desc = "New tab" })
keymap.set('n', 'tc', '<Esc>:tabclose<CR>', { noremap = true, silent = true, desc = "Close tab" })
keymap.set('n', 'th', '<Esc>:tabprevious<CR>', { noremap = true, silent = true, desc = "Previous tab" })
keymap.set('n', 'tl', '<Esc>:tabnext<CR>', { noremap = true, silent = true, desc = "Next tab" })

keymap.set('i', "jj", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })

keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })
keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines up" })

keymap.set('n', '<leader><A-Del>', function()
	local file = vim.fn.expand('%')
	if vim.fn.confirm("Delete " .. file .. "?", "&Yes\n&No") == 1 then
		vim.fn.delete(file)
		vim.cmd('bdelete')
		vim.notify("Deleted: " .. file)
	end
end, { noremap = true, silent = true, desc = "Delete current file" })

keymap.set({ "n", "v" }, "<A-d>", [["_d]], { noremap = true, silent = true, desc = "Delete without yanking" })
keymap.set("n", "<A-x>", '"_x', { noremap = true, silent = true, desc = "Delete char without yanking" })

keymap.set("v", "<A-s>", [[y:<C-u>%s/<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]],
	{ noremap = true, silent = true, desc = "Replace selected text globally" })
keymap.set("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ noremap = true, silent = true, desc = "Replace word under cursor" })

keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

keymap.set("n", "<A-r>", ":reg<CR>:put ", { silent = true, desc = "Show registers and put" })
keymap.set("i", "<A-r>", "<C-r><C-r>", { silent = true, desc = "Insert from register" })
keymap.set('n', '<A-S-r>', function()
	vim.ui.input({ prompt = "Yank to register (a-z): " }, function(char)
		if char and char:match("^[a-z]$") then
			vim.cmd('normal! "' .. char .. 'yy')
			vim.notify("Yanked line to @" .. char)
		end
	end)
end, { noremap = true, silent = true, desc = "Yank line to register" })

keymap.set("n", "<leader>.", "<C-w>v", { noremap = true, silent = true, desc = "Split vertically" })
keymap.set("n", "<leader>,", "<C-w>s", { noremap = true, silent = true, desc = "Split horizontally" })

-- URL handling
local functions = require('functions')
keymap.set("n", "gf", functions.goto_file, { desc = "Go to file or open URL" })
keymap.set("n", "gx", functions.open_url, { desc = "Open URL in browser" })
