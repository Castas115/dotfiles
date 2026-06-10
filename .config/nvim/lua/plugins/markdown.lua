return {
	{
		"MeanderingProgrammer/markdown.nvim",
		main = "render-markdown",
		name = "render-markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {
			checkbox = {
				custom = {
					stopped = { raw = '[/]', rendered = '', highlight = 'RenderMarkdownTodo'},
					doing = { raw = '[_]', rendered = '', highlight = 'RenderMarkdownTodo'},
				},
			},
		},
	},
	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = {
			padd_column_separators = true,
			mappings = {
				next = "<A-TAB>",
				prev = "<S-TAB>",
				insert_row_up = "<A-Up>",
				insert_row_down = "<A-Down>",
				move_row_up = "<A-S-Up>",
				move_row_down = "<A-S-Down>",
				insert_column_left = "<A-Left>",
				insert_column_right = "<A-Right>",
				move_column_left = "<A-S-Left>",
				move_column_right = "<A-S-Right>",
				insert_table = "<A-S-t>",
				insert_table_alt = "<A-C-t>",
				delete_column = "<A-d>",
			},
		},
	},
}
