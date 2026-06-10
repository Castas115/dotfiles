return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"echasnovski/mini.icons",
	},
	opts = {
		notifier = {
			enabled = true,
			top_down = false, -- place notifications from top to bottom
		},
		bigfile = { enabled = true },
		picker = {
			enabled = true,
			previewers = {
				diff = {
					builtin = false,
					cmd = { "delta" },
				},
				file = {
					max_size = 1024 * 1024,
					max_line_length = 500,
					ft = nil,
				},
			},
			formatters = {
				file = {
					filename_first = true,
					truncate = 80,
				},
			},
			win = {
				preview = {
					wo = {
						number = true,
						relativenumber = false,
						signcolumn = "no",
						foldcolumn = "0",
					},
				},
			},
		},
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
