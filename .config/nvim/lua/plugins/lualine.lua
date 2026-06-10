local function get_buffer_count()
	return #vim.fn.getbufinfo({ buflisted = 1 })
end

local function load_theme()
	local path = vim.fn.expand("~/.config/theme/generated/lualine.lua")
	local f = loadfile(path)
	if f then return f() end
	return "auto"
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = load_theme(),
				component_separators = "",
				section_separators = "",
				-- globalstatus = true,
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
					"lsp_status",
					{ "progress", color = { fg = "#ff9e64" } },
					{ "location", color = { fg = "#ff9e64" } },
				},
				lualine_y = { "diagnostics", "diff", "branch" },
				lualine_z = { "mode" },
			},
		})
	end,
}
