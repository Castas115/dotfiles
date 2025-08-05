return {
	{
		"MeanderingProgrammer/markdown.nvim",
		main = "render-markdown",
		opts = {},
		name = "render-markdown",                                                      -- Only needed if you have another plugin named markdown.nvim
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you use the mini.nvim suitable
	},
	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = {
			padd_column_separators = true, -- Insert a space around column separators.
			mappings = {               -- next and prev work in Normal and Insert mode. All other mappings work in Normal mode.
				next = "<A-TAB>",      -- Go to next cell.
				prev = "<S-TAB>",      -- Go to previous cell.
				insert_row_up = "<A-Up>", -- Insert a row above the current row.
				insert_row_down = "<A-Down>", -- Insert a row below the current row.
				move_row_up = "<A-S-Up>", -- Move the current row up.
				move_row_down = "<A-S-Down>", -- Move the current row down.
				insert_column_left = "<A-Left>", -- Insert a column to the left of current column.
				insert_column_right = "<A-Right>", -- Insert a column to the right of current column.
				move_column_left = "<A-S-Left>", -- Move the current column to the left.
				move_column_right = "<A-S-Right>", -- Move the current column to the right.
				insert_table = "<A-S-t>", -- Insert a new table.
				insert_table_alt = "<A-C-t>", -- Insert a new table that is not surrounded by pipes.
				delete_column = "<A-d>", -- Delete the column under cursor.
			},
		},
	},
}
