local set = vim.keymap.set

set("n", "<leader>q", ":q!<CR>", { noremap = true, silent = true, desc = "Quit without saving" })
set("n", "<M-q>", ":qa!<CR>", { noremap = true, silent = true, desc = "Quit all without saving" })
set({ 'n', 'v' }, "<C-S-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
set({ 'n', 'v' }, "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

set({ 'n', 'v', 'i' }, '<C-s>', '<cmd>w<CR>', { noremap = true, silent = true, desc = "Save file" })

set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = "Move to left window" })
set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = "Move to bottom window" })
set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = "Move to top window" })
set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = "Move to right window" })

set({ 'n', 'v' }, "<A-j>", "10jzz", { noremap = true, silent = true, desc = "Scroll down 10 lines" })
set({ 'n', 'v' }, "<A-k>", "10kzz", { noremap = true, silent = true, desc = "Scroll up 10 lines" })
set({ 'n', 'v' }, "<PageUp>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll up half page" })
set({ 'n', 'v' }, "<PageDown>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll down half page" })

set('n', '<A-S-h>', ':vertical resize -4<CR>', { noremap = true, silent = true, desc = "Decrease width" })
set('n', '<A-S-j>', ':resize -2<CR>', { noremap = true, silent = true, desc = "Decrease height" })
set('n', '<A-S-k>', ':resize +2<CR>', { noremap = true, silent = true, desc = "Increase height" })
set('n', '<A-S-l>', ':vertical resize +4<CR>', { noremap = true, silent = true, desc = "Increase width" })

set('n', '<leader>bd', '<cmd>bdelete<CR>', { noremap = true, silent = true, desc = "Delete buffer" })

set('i', "jj", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })

set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })
set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })

set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines down" })
set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines up" })

set('n', '<leader><A-Del>', function()
	local file = vim.fn.expand('%')
	if vim.fn.confirm("Delete " .. file .. "?", "&Yes\n&No") == 1 then
		vim.fn.delete(file)
		vim.cmd('bdelete')
		vim.notify("Deleted: " .. file)
	end
end, { noremap = true, silent = true, desc = "Delete current file" })

set({ "n", "v" }, "<A-d>", [["_d]], { noremap = true, silent = true, desc = "Delete without yanking" })
set("n", "<A-x>", '"_x', { noremap = true, silent = true, desc = "Delete char without yanking" })

set("v", "<A-s>", [[y:<C-u>%s/<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]],
	{ noremap = true, silent = true, desc = "Replace selected text globally" })
set("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ noremap = true, silent = true, desc = "Replace word under cursor" })

set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

set("n", "<leader>.", "<C-w>v", { noremap = true, silent = true, desc = "Split vertically" })
set("n", "<leader>,", "<C-w>s", { noremap = true, silent = true, desc = "Split horizontally" })

set("n", "gf", require("util.url").goto_file, { desc = "Go to file or open URL" })

set("n", "<leader>fv", function()
	local word = vim.fn.expand("<cword>")
	local cmd = ":vimgrep " .. word .. " **"
	local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
	vim.api.nvim_feedkeys(cmd .. string.rep(left, 3), "n", false)
end, { noremap = true, silent = false, desc = "vimgrep current word (editable)" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = vim.api.nvim_create_augroup("markdown_keymaps", { clear = true }),
	callback = function(args)
		local md = require("util.markdown")
		local buf = args.buf
		set("n", "<leader>td", md.write_current_day, { buffer = buf, desc = "Insert current day header" })
		set({ "n", "i" }, "<A-x>", md.toggle_checkbox, { buffer = buf, desc = "Toggle checkbox" })
		set({ "n", "i" }, "<A-S-x>", md.task_toggle_done, { buffer = buf, desc = "Toggle task and move to done" })
	end,
})
