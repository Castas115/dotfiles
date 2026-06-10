return {
	{
		"echasnovski/mini.surround",
		keys = {
			{ "sa", mode = { "n", "v" } },
			{ "sd" },
			{ "sf" },
			{ "sF" },
			{ "sh" },
			{ "sr" },
			{ "sn" },
		},
		opts = {
			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",
				suffix_last = "l",
				suffix_next = "n",
			},
			n_lines = 20,
			search_method = "cover",
			silent = false,
		},
	},
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = {
			mappings = {
				around = "a",
				inside = "i",
				around_next = "an",
				inside_next = "in",
				around_last = "al",
				inside_last = "il",
				goto_left = "g[",
				goto_right = "g]",
			},
			n_lines = 50,
			search_method = "cover_or_next",
			silent = false,
		},
	},
	{
		"echasnovski/mini.files",
		keys = {
			{ "<leader>E", "<cmd>lua MiniFiles.open()<CR>", desc = "Toggle mini file explorer" },
			{
				"<leader>e",
				function()
					local MiniFiles = require("mini.files")
					MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
					MiniFiles.reveal_cwd()
				end,
				desc = "Toggle into currently opened file",
			},
		},
		config = function()
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				mappings = {
					go_in = "<CR>",
					go_in_plus = "L",
					go_out = "-",
					go_out_plus = "H",
				},
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					vim.keymap.set("n", "<C-s>", MiniFiles.synchronize, { buffer = args.data.buf_id, desc = "Save changes" })
					vim.keymap.set("n", "<Esc>", MiniFiles.close, { buffer = args.data.buf_id, desc = "Close mini files" })
				end,
			})
		end,
	},
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"echasnovski/mini.comment",
		keys = {
			{ "<leader>c", mode = { "n", "v" } },
			{ "<leader>cc" },
		},
		opts = {
			mappings = {
				comment = "<leader>c",
				comment_line = "<leader>cc",
				comment_visual = "<leader>c",
				textobject = "<leader>c",
			},
		},
	},
}
