local function get_buffer_count()
  local buffers = vim.fn.execute("ls")
  local count = 0
  -- Match only lines that represent buffers, typically starting with a number followed by a space
  for line in string.gmatch(buffers, "[^\r\n]+") do
    if string.match(line, "^%s*%d+") then
      count = count + 1
    end
  end
  return count
end

return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require('lualine').setup({
			options = {
				theme = 'iceberg_dark',
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_a = {get_buffer_count},
				lualine_b = { {
					'filename',
					file_status = true, -- Display modified/read-only status
					path = 1,
				}},
				lualine_c = {},
				-- lualine_c = {
				-- 	{ require('NeoComposer.ui').status_recording },
				-- },
				lualine_x = {
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#ff9e64" },
					},
					{
						'location',
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = {'branch', 'diff', 'diagnostics'},
				lualine_z = {'mode'}
			}
		})
	end
}
