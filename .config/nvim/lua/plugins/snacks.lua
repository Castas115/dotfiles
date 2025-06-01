return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"echasnovski/mini.icons",
	},
	opts = {
		-- lazygit = {
		-- 	theme = {
		-- 		selectedLineBgColor = { bg = "CursorLine" },
		-- 	},
		-- },
		notifier = {
			enabled = true,
			top_down = false, -- place notifications from top to bottom
		},
		bigfile = { enabled = true },
		picker = { enabled = true },
		indent = {
			scope = { enabled = true },
			animate = {
				duration = {
					step = 15, -- ms per step
					total = 80, -- maximum duration
				},
			},
		},
	},
	keys = {
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<C-n>",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer",
		},
	},
}
