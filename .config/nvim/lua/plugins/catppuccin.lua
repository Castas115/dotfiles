-- Read active theme from ~/.config/theme/current
local function get_flavour()
	local f = io.open(vim.fn.expand("~/.config/theme/current"), "r")
	if not f then return "mocha" end
	local mode = (f:read("*l") or "dark"):gsub("%s+", "")
	f:close()
	return mode == "light" and "latte" or "mocha"
end

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function(_,opts)
		opts.flavour = get_flavour()
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
	opts = {
		no_italic = true,
		term_colors = true,
		transparent_background = false,
		styles = {
			comments = {},
			conditionals = {},
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
		},
		color_overrides = {
			mocha = {
				base = "#000000",
				mantle = "#000000",
				crust = "#000000",
			},
			latte = {
				base = "#ffffff",
				mantle = "#ffffff",
				crust = "#ffffff",
			},
		},
		integrations = {
			telescope = {
				enabled = true,
				style = "nvchad",
			},
			dropbar = {
				enabled = true,
				color_mode = true,
			},
		},
	},
}
