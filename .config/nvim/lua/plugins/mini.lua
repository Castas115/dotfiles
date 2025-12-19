return {
	{
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup({
				-- Add custom surroundings to be used on top of builtin ones. For more
				-- information with examples, see `:h MiniSurround.config`.
				custom_surroundings = nil,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					add = "sa", -- Add /surrounding/ in Normal and Visual modes
					delete = "sd", -- Delete surrounding
					find = "sf", -- Find surrounding (to the right)
					find_left = "sF", -- Find surrounding (to the left)
					highlight = "sh", -- Highlight surrounding
					replace = "sr", -- Replace surrounding
					update_n_lines = "sn", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},

				n_lines = 20, -- Number of lines within which surrounding is searched

				-- How to search for surrounding (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
				-- see `:h MiniSurround.config`.
				search_method = "cover",
				silent = false,
			})
		end,
	},
	{
		"echasnovski/mini.ai",
		config = function()
			require("mini.ai").setup({
				--{ ( `Table` "with" 'textobject' ``) }id as fields(), textobject specification as values.
				-- Also use this to disable builtin textobjects. See |MiniAi.config|.
				custom_textobjects = nil,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Main textobject prefixes
					around = "a",
					inside = "i",

					-- Next/last variants
					around_next = "an",
					inside_next = "in",
					around_last = "al",
					inside_last = "il",

					-- Move cursor to corresponding edge of `a` textobject
					goto_left = "g[",
					goto_right = "g]",
				},

				-- Number of lines within which textobject is searched
				n_lines = 50,

				-- How to search for object (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
				search_method = "cover_or_next",

				-- Whether to disable showing non-error feedback
				-- This also affects (purely informational) helper messages shown after
				-- idle time if user input is required.
				silent = false,
			})
		end,
	},
	{
		"echasnovski/mini.files",
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
	{
		"echasnovski/mini.notify",
	},
	-- {
	-- 	"echasnovski/mini.indentscope",
	-- 	version = false, -- wait till new 0.7.0 release to put it back on semver
	-- 	opts = {
	-- 		-- symbol = "▏",
	-- 		symbol = "│",
	-- 		options = { try_as_border = true },
	-- 		draw = {
	-- 			delay = 0,

	-- 			-- Animation rule for scope's first drawing. A function which, given
	-- 			-- next and total step numbers, returns wait time (in ms). See
	-- 			-- |MiniIndentscope.gen_animation| for builtin options. To disable
	-- 			-- animation, use `require('mini.indentscope').gen_animation.none()`.
	-- 			-- animation = --<function: implements constant 20ms between steps>,

	-- 			-- Whether to auto draw scope: return `true` to draw, `false` otherwise.
	-- 			-- Default draws only fully computed scope (see `options.n_lines`).
	-- 			predicate = function(scope)
	-- 				return not scope.body.is_incomplete
	-- 			end,

	-- 			-- Symbol priority. Increase to display on top of more symbols.
	-- 			priority = 2,
	-- 		},
	-- 	},
	-- },
}
