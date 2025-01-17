local function today_diary()
	local second_brain_path = "~/Documents/secondBrain"

	vim.cmd("cd " .. second_brain_path)

	local current_date = os.date("%y-%m-%d-%a")
	local file_path = second_brain_path  .. "/diario/" .. current_date .. ".md"
	vim.cmd("edit " .. file_path)
end

-- vim.keymap.set("n", "<leader>td", today_diary, { noremap = true, silent = true })

local function diff_with_copy()
	-- Get the current file path and extension
	print("a")
	local current_file = vim.fn.expand("%:p")
	local file_name = vim.fn.expand("%:t:r") -- Get the base name without extension
	local file_ext = vim.fn.expand("%:e") -- Get the file extension

	if current_file == "" then
		print("No file is currently open!")
		return
	end

	-- Create the new file name with .diff before the extension
	local copy_file = vim.fn.fnamemodify(current_file, ":h") .. "/" .. file_name .. ".diff." .. file_ext

	-- Write the current buffer to the copy file
	vim.cmd("write " .. copy_file)

	-- Open a diff view comparing the original file and the copy
	vim.cmd("tabnew") -- Open in a new tab
	vim.cmd("execute 'terminal nvim -d " .. current_file .. " " .. copy_file .. "'")
end

-- vim.keymap.set("n", "<leader>d", diff_with_copy, { noremap = true, silent = true })

local function write_current_day()
	local lines = {
		"___",
		os.date("### ***%Y-%m-%d %a***"),
		"",
		""
	}
	vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
	vim.api.nvim_win_set_cursor(0, { 3, 0 })
end

vim.keymap.set("n", "td", write_current_day, { noremap = true, silent = true })

local function checkmark()

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = vim.api.nvim_get_current_line()

	if not current_line:match("^%s*%- %[") then
		vim.cmd("normal!I- [ ] ")
	elseif current_line:match("^%s*%- %[ %]") then
		local updated_line = current_line:gsub("%- %[ %]", "- [x]")
		vim.api.nvim_set_current_line(updated_line)
	elseif current_line:match("^%s*%- %[x%]") then
		local updated_line = current_line:gsub("%- %[x%]", "- [ ]")
		vim.api.nvim_set_current_line(updated_line)
	end

	vim.api.nvim_win_set_cursor(0, cursor_pos)
end

vim.keymap.set({"n","i"}, "<C-c>", checkmark, { noremap = true, silent = true, desc = "Create checkmark on line"})
