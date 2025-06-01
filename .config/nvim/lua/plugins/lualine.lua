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

local colors = {
	color9 = "#3e445e",

	normal = "#818596",
	insert = "#84a0c6",
	visual = "#b4be82",
	replace = "#e2a478",

	background = "#16171f",
	black = "#000000",
	text = "#c6c8d1",
}

local custom_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.normal, gui = "bold" },
		b = { fg = colors.text, bg = colors.background },
		c = { fg = colors.text, bg = colors.black },
	},
	insert = {
		a = { fg = colors.black, bg = colors.insert, gui = "bold" },
	},
	visual = {
		a = { fg = colors.black, bg = colors.visual, gui = "bold" },
	},
	replace = {
		a = { fg = colors.black, bg = colors.replace, gui = "bold" },
	},
	inactive = {
		a = { fg = colors.color9, bg = colors.black, gui = "bold" },
		b = { fg = colors.color9, bg = colors.black },
		c = { fg = colors.color9, bg = colors.black },
	},
}
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = custom_theme,
				component_separators = "",
				section_separators = "",
				globalstatus = true,
			},
			sections = {
				lualine_a = { get_buffer_count },
				lualine_b = {
					{
						"filename",
						file_status = true,
						path = 1,
					},
				},
				lualine_c = {
					"searchcount",
				},
				lualine_x = {
					{
						"lsp_status",
						ignore_lsp = { "null-ls", "Augment Server" },
					},
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#ff9e64" },
					},
					{
						"progress",
						color = { fg = "#ff9e64" },
					},
					{
						"location",
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = { "diagnostics", "diff", "branch" },
				lualine_z = { "mode" },
			},
		})
	end,
}
