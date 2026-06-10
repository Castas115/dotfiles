local M = {}

local URL_PATTERN = "https?://[^%s)]+"

local function find_under_cursor(line, col, pattern)
	local pos = 1
	while true do
		local s, e = line:find(pattern, pos)
		if not s then return nil end
		if col >= s and col <= e + 1 then
			return line:sub(s, e)
		end
		pos = e + 1
	end
end

local function find_paren_content(line, col)
	local pos = 1
	while true do
		local s, e = line:find("%b()", pos)
		if not s then return nil end
		if col >= s and col <= e then
			return line:sub(s + 1, e - 1)
		end
		pos = e + 1
	end
end

local function find_markdown_link_target(line, col)
	local pos = 1
	while true do
		local lb, rb = line:find("%[.-%]", pos)
		if not lb then return nil end
		if line:sub(rb + 1, rb + 1) == "(" then
			local pe = line:find(")", rb + 2, true)
			if pe and col >= lb and col <= rb then
				return line:sub(rb + 2, pe - 1)
			end
			pos = (pe or rb) + 1
		else
			pos = rb + 1
		end
	end
end

local function open_in_browser(url)
	local cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
	vim.fn.jobstart({ cmd, url }, { detach = true })
	vim.notify("Opening: " .. url)
end

local function open_target(target)
	if target:match("^" .. URL_PATTERN .. "$") then
		open_in_browser(target)
	else
		vim.cmd("edit " .. vim.fn.fnameescape(target))
	end
end

function M.goto_file()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1

	local url = find_under_cursor(line, col, URL_PATTERN)
	if url then
		return open_in_browser(url)
	end

	local link_target = find_markdown_link_target(line, col)
	if link_target then
		return open_target(link_target)
	end

	local paren = find_paren_content(line, col)
	if paren and paren ~= "" then
		return open_target(paren)
	end

	local cfile = vim.fn.expand("<cfile>")
	local looks_like_path = cfile:match("[/.]") ~= nil
	if cfile ~= "" and (looks_like_path or vim.fn.filereadable(cfile) == 1) then
		vim.cmd("edit " .. vim.fn.fnameescape(cfile))
	else
		vim.notify("No file or URL found", vim.log.levels.WARN)
	end
end

return M
