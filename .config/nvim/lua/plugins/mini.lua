return {
	{
		'echasnovski/mini.surround',
		config = function()
			require('mini.surround').setup {
				{
					-- Add custom surroundings to be used on top of builtin ones. For more
					-- information with examples, see `:h MiniSurround.config`.
					custom_surroundings = nil,

					-- Module mappings. Use `''` (empty string) to disable one.
					mappings = {
						add = 'sa', -- Add /surrounding/ in Normal and Visual modes
						delete = 'sd', -- Delete surrounding
						find = 'sf', -- Find surrounding (to the right)
						find_left = 'sF', -- Find surrounding (to the left)
						highlight = 'sh', -- Highlight surrounding
						replace = 'sr', -- Replace surrounding
						update_n_lines = 'sn', -- Update `n_lines`

						suffix_last = 'l', -- Suffix to search with "prev" method
						suffix_next = 'n', -- Suffix to search with "next" method
					},

					n_lines = 20, -- Number of lines within which surrounding is searched

					-- How to search for surrounding (first inside current line, then inside
					-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
					-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
					-- see `:h MiniSurround.config`.
					search_method = 'cover',
					silent = false,
				}
			}
		end
	}, {
		'echasnovski/mini.files',
		config = function()
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				mappings = {
					go_in = "<CR>", -- Map both Enter and L to enter directories or open files
					go_in_plus = "L",
					go_out = "-",
					go_out_plus = "H",
				},
			})
			vim.keymap.set("n", "<leader>E", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" }) -- toggle file explorer
			vim.keymap.set("n", "<leader>e", function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
				MiniFiles.reveal_cwd()
			end, { desc = "Toggle into currently opened file" })
		end,
	},

}
