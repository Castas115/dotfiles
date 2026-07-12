-- Dedicated colorscheme plugins, one per theme in ~/.config/theme.
-- All transparent so tmux provides the pane bg (black active / dim inactive).
-- apply-theme.sh runs `:colorscheme <nvim_colorscheme>`; init.lua applies the
-- active one at startup from generated/colorscheme.lua.
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			transparent_background = true,
			no_italic = true,
			term_colors = true,
			color_overrides = {
				mocha = { base = "#000000", mantle = "#000000", crust = "#000000" },
				latte = { base = "#ffffff", mantle = "#ffffff", crust = "#ffffff" },
			},
			integrations = {
				snacks = { enabled = true, indent_scope_color = "lavender" },
				dropbar = { enabled = true, color_mode = true },
			},
		},
	},
	{ "ellisonleao/gruvbox.nvim", lazy = true, opts = { transparent_mode = true } },
	{ "folke/tokyonight.nvim", lazy = true, opts = { transparent = true, style = "night" } },
	{
		"shaunsingh/nord.nvim",
		lazy = true,
		init = function()
			vim.g.nord_disable_background = true
			vim.g.nord_italic = false
		end,
	},
	{ "rose-pine/neovim", name = "rose-pine", lazy = true, opts = { styles = { transparency = true } } },
	{ "Mofiqul/dracula.nvim", lazy = true, opts = { transparent_bg = true } },
}
