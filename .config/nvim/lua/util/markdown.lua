local M = {}

local LABEL_DONE = "done:"
local TASKS_HEADING = "## Completed tasks"
local TIMESTAMP_FMT = "%y%m%d-%H%M"

M.checkbox_cycle = { " ", "_", "/", "x" }

function M.write_current_day()
	local lines = {
		"___",
		os.date("# ***%Y-%m-%d %a**, %H:%M*"),
		"",
		"",
	}
	vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
	vim.api.nvim_win_set_cursor(0, { 4, 0 })
end

function M.toggle_checkbox()
	local current_line = vim.api.nvim_get_current_line()
	local row = vim.api.nvim_win_get_cursor(0)[1]

	if not current_line:match("^%s*%- %[") then
		local is_empty = current_line:match("^%s*$") ~= nil
		local lead_len = #(current_line:match("^(%s*)") or "")
		vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, lead_len, { "- [ ] " })
		if is_empty then
			vim.cmd("startinsert!")
		end
		return
	end

	local state = current_line:match("^%s*%- %[(.)%]")
	if not state then return end

	local next_state = " "
	for i, s in ipairs(M.checkbox_cycle) do
		if s == state then
			next_state = M.checkbox_cycle[(i % #M.checkbox_cycle) + 1]
			break
		end
	end

	local bracket_pos = current_line:find("%- %[")
	vim.api.nvim_buf_set_text(0, row - 1, bracket_pos + 2, row - 1, bracket_pos + 3, { next_state })
end

-- pure transforms on bullet lines --
local function bullet_to_x(line) return (line:gsub("^(%s*%- )%[%s*%]", "%1[x]")) end
local function bullet_to_blank(line) return (line:gsub("^(%s*%- )%[x%]", "%1[ ]")) end

local function insert_label(line, label)
	local prefix = line:match("^(%s*%- %[[x ]%])")
	if not prefix then return line end
	return prefix .. " " .. label .. line:sub(#prefix + 1)
end

local function remove_label(line)
	return (line:gsub("^(%s*%- %[[x ]%])%s+`.-`", "%1"))
end

-- find buffer regions --
local function locate_bullet_start(lines, start)
	while start > 0 do
		local t = lines[start + 1]
		if t == "" or t:match("^%s*%-") then break end
		start = start - 1
	end
	if lines[start + 1] == "" and start < (#lines - 1) then
		start = start + 1
	end
	return start
end

local function locate_chunk_end(lines, start)
	local e = start
	while e + 1 < #lines do
		local nxt = lines[e + 2]
		if nxt == "" or nxt:match("^%s*%-") then break end
		e = e + 1
	end
	return e
end

local function find_header_above(lines, idx)
	for i = idx - 1, 0, -1 do
		local t = lines[i + 1]
		if t:match("^### ") then
			return "*" .. t:gsub("^###%s*", ""):gsub("%s+", "_"):lower() .. "*"
		end
	end
end

-- detect chunk state via inline label syntax --
local function normalize_chunk_labels(chunk)
	for i, line in ipairs(chunk) do
		chunk[i] = line
			:gsub("%[done:([^%]]+)%]", "`" .. LABEL_DONE .. "%1`")
			:gsub("%[untoggled%]", "`untoggled`")
	end
end

local function find_index(chunk, pattern)
	for i, line in ipairs(chunk) do
		if line:match(pattern) then return i end
	end
end

function M.task_toggle_done()
	local buf = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()
	local view = vim.api.nvim_win_call(win, function() return vim.fn.winsaveview() end)

	local start = vim.api.nvim_win_get_cursor(0)[1] - 1
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	if start >= #lines then return end

	start = locate_bullet_start(lines, start)
	local bullet_line = lines[start + 1] or ""
	if not bullet_line:match("^%s*%- %[[x ]%]") then
		vim.notify("Not a task bullet", vim.log.levels.WARN)
		return
	end

	local chunk_start = start
	local chunk_end = locate_chunk_end(lines, start)

	local chunk = {}
	for i = chunk_start, chunk_end do
		table.insert(chunk, lines[i + 1])
	end

	normalize_chunk_labels(chunk)
	local done_idx = find_index(chunk, "`" .. LABEL_DONE .. ".-`")
	local untoggled_idx = not done_idx and find_index(chunk, "`untoggled`") or nil

	local timestamp = os.date(TIMESTAMP_FMT)

	local function write_chunk_back()
		for i = chunk_start, chunk_end do
			lines[i + 1] = chunk[i - chunk_start + 1]
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	end

	if done_idx then
		chunk[done_idx] = remove_label(chunk[done_idx]):gsub("`" .. LABEL_DONE .. ".-`", "`untoggled`")
		chunk[1] = bullet_to_blank(chunk[1])
		chunk[1] = remove_label(chunk[1])
		chunk[1] = insert_label(chunk[1], "`untoggled`")
		write_chunk_back()
		vim.notify("Untoggled", vim.log.levels.INFO)
	elseif untoggled_idx then
		local label = "`" .. LABEL_DONE .. " " .. timestamp .. "`"
		chunk[untoggled_idx] = remove_label(chunk[untoggled_idx]):gsub("`untoggled`", label)
		chunk[1] = bullet_to_x(chunk[1])
		chunk[1] = remove_label(chunk[1])
		chunk[1] = insert_label(chunk[1], label)
		write_chunk_back()
		vim.notify("Completed", vim.log.levels.INFO)
	else
		local header_tag = find_header_above(lines, chunk_start)
		local done_label = "`" .. LABEL_DONE .. " " .. timestamp .. "`"
		if header_tag then done_label = done_label .. " " .. header_tag end

		chunk[1] = bullet_to_x(chunk[1])
		chunk[1] = insert_label(chunk[1], done_label)

		for i = chunk_end, chunk_start, -1 do
			table.remove(lines, i + 1)
		end

		local heading_idx
		for i, line in ipairs(lines) do
			if line:match("^" .. vim.pesc(TASKS_HEADING)) then
				heading_idx = i
				break
			end
		end

		if heading_idx then
			for _, cLine in ipairs(chunk) do
				table.insert(lines, heading_idx + 1, cLine)
				heading_idx = heading_idx + 1
			end
			if lines[heading_idx + 1] == "" then
				table.remove(lines, heading_idx + 1)
			end
		else
			table.insert(lines, TASKS_HEADING)
			for _, cLine in ipairs(chunk) do
				table.insert(lines, cLine)
			end
		end

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.notify("Completed", vim.log.levels.INFO)
	end

	vim.api.nvim_win_call(win, function() vim.fn.winrestview(view) end)
	vim.cmd("silent update")
end

return M
