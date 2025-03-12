return {
	{
		"lewis6991/gitsigns.nvim",
		config =function ()
			require("gitsigns").setup()
			vim.keymap.set('n', "<leader>gp", ':Gitsigns preview_hunk<CR>', { desc = "Git preview hunk" })
			vim.keymap.set('n', "<leader>gi", ':Gitsigns preview_hunk_inline<CR>', { desc = "Git preview hunk inline" })
			vim.keymap.set('n', "<leader>gb", ':Gitsigns toggle_current_line_blame<CR>', { desc = "Git blame" })
		end
	},{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = 'Neogit',
		keys = {
			{ '<leader>gg', ':Neogit<cr>', desc = 'neo[g]it' },
		},
		config = function()
			require('neogit').setup {
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			}
		end,
	}
}

