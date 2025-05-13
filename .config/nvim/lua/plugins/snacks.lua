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
	},
	keys = {
		{ "<leader>gl", function() Snacks.lazygit.log_file() end,	desc = "Lazygit Log (cwd)" },
		{ "<leader>lg", function() Snacks.lazygit() end,			desc = "Lazygit" },
		{ "<leader>fr", function() Snacks.picker.recent() end,      desc = "Recent Files" },
		{ "<C-n>",      function() Snacks.explorer() end,			 desc = "Explorer" },
	}
}
