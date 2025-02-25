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
		os.date("# ***%Y-%m-%d %a**, %H:%M*"),
		"",
		"",
		""
	}
	vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
	vim.api.nvim_win_set_cursor(0, { 4, 0 })
end

vim.keymap.set("n", "td", write_current_day, { noremap = true, silent = true })

local function toggle_checkbox()

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = vim.api.nvim_get_current_line()

	if not current_line:match("^%s* %- %[") then
		vim.cmd("normal!I - [ ] ")
        vim.api.nvim_win_set_cursor(0, { cursor_pos[1], #current_line })
	elseif current_line:match("^%s* %- %[ %]") then
		local updated_line = current_line:gsub("%- %[ %]", "- [-]")
		vim.api.nvim_set_current_line(updated_line)
	elseif current_line:match("^%s* %- %[%x%]") then
		local updated_line = current_line:gsub("%- %[%x%]", "- [ ]")
		vim.api.nvim_set_current_line(updated_line)
	elseif current_line:match("^%s* %- %[%-%]") then
		local updated_line = current_line:gsub("%- %[%-%]", "- [ ]")
		vim.api.nvim_set_current_line(updated_line)
	end

  -- -- Check if the line starts with a bullet or "- ", and remove it
  -- local updated_line = line:gsub("^%s*[-*]%s*", "", 1)
  -- -- Update the line
  -- vim.api.nvim_set_current_line(updated_line)
  -- -- Move the cursor back to its original position
  -- vim.api.nvim_win_set_cursor(0, { cursor[1], #updated_line })
  -- -- Insert the checkbox
  -- vim.api.nvim_put({ "- [ ] " }, "c", true, true)
	-- vim.api.nvim_win_set_cursor(0, cursor_pos)
end

vim.keymap.set({"n","v","i"}, "<M-c>", toggle_checkbox, { noremap = true, silent = true, desc = "Toggle checkbox"})

vim.keymap.set("n", "<M-x>", function()
  -- Customizable variables
  local label_done = "done:"  -- Label for completed tasks
  local timestamp = os.date("%y%m%d-%H%M")  -- Timestamp format
  local tasks_heading = "## Completed tasks"  -- Heading for completed tasks

  -- Save the view to preserve folds
  vim.cmd("mkview")
  local api = vim.api

  -- Retrieve buffer & lines
  local buf = api.nvim_get_current_buf()
  local cursor_pos = api.nvim_win_get_cursor(0)
  local start_line = cursor_pos[1] - 1
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  local total_lines = #lines

  -- If cursor is beyond last line, do nothing
  if start_line >= total_lines then
    vim.cmd("loadview")
    return
  end

  -- (A) Move upwards to find the bullet line
  while start_line > 0 do
    local line_text = lines[start_line + 1]
    if line_text == "" or line_text:match("^%s*%-") then
      break
    end
    start_line = start_line - 1
  end

  -- Adjust start_line if on a blank line
  if lines[start_line + 1] == "" and start_line < (total_lines - 1) then
    start_line = start_line + 1
  end

  -- (B) Validate that it's a task bullet
  local bullet_line = lines[start_line + 1]
  if not bullet_line:match("^%s*%- %[[x ]%]") then
    print("Not a task bullet: no action taken.")
    vim.cmd("loadview")
    return
  end

  -- 1. Identify the chunk boundaries
  local chunk_start = start_line
  local chunk_end = start_line
  while chunk_end + 1 < total_lines do
    local next_line = lines[chunk_end + 2]
    if next_line == "" or next_line:match("^%s*%-") then
      break
    end
    chunk_end = chunk_end + 1
  end

  -- Collect the chunk lines
  local chunk = {}
  for i = chunk_start, chunk_end do
    table.insert(chunk, lines[i + 1])
  end

  -- 2. Check if chunk has [done: ...] or [untoggled], then transform them
  local has_done_index = nil
  local has_untoggled_index = nil
  for i, line in ipairs(chunk) do
    chunk[i] = line:gsub("%[done:([^%]]+)%]", "`" .. label_done .. "%1`")
    chunk[i] = chunk[i]:gsub("%[untoggled%]", "`untoggled`")
    if chunk[i]:match("`" .. label_done .. ".-`") then
      has_done_index = i
      break
    end
  end
  if not has_done_index then
    for i, line in ipairs(chunk) do
      if line:match("`untoggled`") then
        has_untoggled_index = i
        break
      end
    end
  end

  -- 3. Helpers to toggle bullet
  local function bulletToX(line)
    return line:gsub("^(%s*%- )%[%s*%]", "%1[x]")
  end
  local function bulletToBlank(line)
    return line:gsub("^(%s*%- )%[x%]", "%1[ ]")
  end

  -- 4. Insert or remove label *after* the bracket
  local function insertLabelAfterBracket(line, label)
    local prefix = line:match("^(%s*%- %[[x ]%])")
    if not prefix then
      return line
    end
    local rest = line:sub(#prefix + 1)
    return prefix .. " " .. label .. rest
  end
  local function removeLabel(line)
    return line:gsub("^(%s*%- %[[x ]%])%s+`.-`", "%1")
  end

  -- 5. Find the closest `###` header
  local function findClosestHeader(task_line)
    for i = task_line - 1, 0, -1 do
      local line_text = lines[i + 1]
      if line_text:match("^### ") then
        -- Extract header text and convert to tag format
        local header_text = line_text:gsub("^###%s*", ""):gsub("%s+", "_"):lower()
        return "#" .. header_text
      end
    end
    return nil  -- No header found
  end

  -- 6. Update the buffer with new chunk lines (in place)
  local function updateBufferWithChunk(new_chunk)
    for idx = chunk_start, chunk_end do
      lines[idx + 1] = new_chunk[idx - chunk_start + 1]
    end
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end

  -- 7. Main toggle logic
  if has_done_index then
    chunk[has_done_index] = removeLabel(chunk[has_done_index]):gsub("`" .. label_done .. ".-`", "`untoggled`")
    chunk[1] = bulletToBlank(chunk[1])
    chunk[1] = removeLabel(chunk[1])
    chunk[1] = insertLabelAfterBracket(chunk[1], "`untoggled`")
    updateBufferWithChunk(chunk)
    vim.notify("Untoggled", vim.log.levels.INFO)
  elseif has_untoggled_index then
    chunk[has_untoggled_index] =
      removeLabel(chunk[has_untoggled_index]):gsub("`untoggled`", "`" .. label_done .. " " .. timestamp .. "`")
    chunk[1] = bulletToX(chunk[1])
    chunk[1] = removeLabel(chunk[1])
    chunk[1] = insertLabelAfterBracket(chunk[1], "`" .. label_done .. " " .. timestamp .. "`")
    updateBufferWithChunk(chunk)
    vim.notify("Completed", vim.log.levels.INFO)
  else
    -- Find the closest `###` header and add it as a tag
    local header_tag = findClosestHeader(start_line)
    local done_label = "`" .. label_done .. " " .. timestamp .. "`"
    if header_tag then
      done_label = done_label .. " " .. header_tag
    end

    -- Save original window view before modifications
    local win = api.nvim_get_current_win()
    local view = api.nvim_win_call(win, function()
      return vim.fn.winsaveview()
    end)

    -- Toggle the task and add the label
    chunk[1] = bulletToX(chunk[1])
    chunk[1] = insertLabelAfterBracket(chunk[1], done_label)

    -- Remove chunk from the original lines
    for i = chunk_end, chunk_start, -1 do
      table.remove(lines, i + 1)
    end

    -- Append chunk under 'tasks_heading'
    local heading_index = nil
    for i, line in ipairs(lines) do
      if line:match("^" .. tasks_heading) then
        heading_index = i
        break
      end
    end
    if heading_index then
      for _, cLine in ipairs(chunk) do
        table.insert(lines, heading_index + 1, cLine)
        heading_index = heading_index + 1
      end
      -- Remove any blank line right after newly inserted chunk
      local after_last_item = heading_index + 1
      if lines[after_last_item] == "" then
        table.remove(lines, after_last_item)
      end
    else
      table.insert(lines, tasks_heading)
      for _, cLine in ipairs(chunk) do
        table.insert(lines, cLine)
      end
      local after_last_item = #lines + 1
      if lines[after_last_item] == "" then
        table.remove(lines, after_last_item)
      end
    end

    -- Update buffer content
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.notify("Completed", vim.log.levels.INFO)

    -- Restore window view to preserve scroll position
    api.nvim_win_call(win, function()
      vim.fn.winrestview(view)
    end)
  end

  -- Write changes and restore view to preserve folds
  vim.cmd("silent update")
  vim.cmd("loadview")
end, { desc = "[P]Toggle task and move it to 'done'" })

