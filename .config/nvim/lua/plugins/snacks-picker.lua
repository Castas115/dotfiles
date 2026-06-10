return {
	"folke/snacks.nvim",
	keys = {
		{
			"H",
			function()
				Snacks.picker.buffers({
					sort_lastused = true,
					layout = "ivy",
					focus = "list",
					on_show = function(picker)
						picker:action("list_down")
					end,
					win = {
						input = {
							keys = {
								["d"] = { "bufdelete", mode = "n" },
							},
						},
						list = {
							keys = {
								["d"] = "bufdelete",
							},
						},
					},
				})
			end,
			desc = "List Buffers",
		},
		{ "<leader><leader>", "<cmd>e #<cr>", desc = "Alternate Buffer" },
		{
			"<leader>ff",
			function()
				Snacks.picker.smart({
					multi = { "buffers", "recent", "files" },
					filter = { cwd = true },
					layout = "ivy",
					on_show = function(picker)
						picker:action("list_down")
					end,
				})
			end,
			desc = "Find Files (smart: buffers + recent + files)",
		},
		{
			"<leader>fu",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.grep({ layout = "ivy" })
			end,
			desc = "Grep in Root Dir",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep_word({ layout = "ivy" })
			end,
			mode = { "n", "v" },
			desc = "Grep Word Under Cursor",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Last Picker",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_status({ layout = "ivy" })
			end,
			desc = "Git Status",
		},
		{
			"<leader>gc",
			function()
				Snacks.picker.git_log({ layout = "ivy" })
			end,
			desc = "Git Commits",
		},
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches({ layout = "ivy" })
			end,
			desc = "Git Branches",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps({ layout = "ivy" })
			end,
			desc = "Find Keymaps",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.lsp_symbols({ layout = "ivy" })
			end,
			desc = "Find Symbols (buffer)",
		},
		{
			"<leader>fS",
			function()
				Snacks.picker.lsp_workspace_symbols({ layout = "ivy" })
			end,
			desc = "Find Symbols (workspace)",
		},
		{
			"<leader>fo",
			function()
				Snacks.picker.recent({ layout = "ivy" })
			end,
			desc = "Old Files (global)",
		},
		{
			"<leader>fd",
			function()
				Snacks.picker.diagnostics({ layout = "ivy" })
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help({ layout = "ivy" })
			end,
			desc = "Help Tags",
		},
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification Panel",
		},
	},
}
