return {
	{
		"echasnovski/mini.diff",
		version = "*",
		config = function()
			require("mini.diff").setup({
				vim.keymap.set("n", "<leader>gD", ":lua MiniDiff.toggle_overlay()<CR>", { desc = "Git diff" }),
				view = {
					style = "sign", -- 'number' or 'sign',
					signs = { add = "┃", change = "┃", delete = "▁" },
					priority = 199, -- Priority of used visualization extmarks
				},

				mappings = {
					apply = "gh",
					reset = "gH",
					textobject = "gh",

					goto_first = "[H",
					goto_prev = "[h",
					goto_next = "]h",
					goto_last = "]H",
				},
			})
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gn", ":Neogit kind=floating<cr>", desc = "neo[g]it" },
		},
		config = function()
			require("neogit").setup({
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()

			vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<CR>", { desc = "Git Diff"})
			-- vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Git Blame line"})
			vim.keymap.set("n", "<leader>gb", ":Gitsigns blame<CR>", { desc = "Git Blame"})
			
		end,
	},
}
