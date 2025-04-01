return {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		{'kkharji/sqlite.lua', module = 'sqlite'},
		{'nvim-telescope/telescope.nvim'},
	},
	config = function()

		vim.keymap.set({ 'n', 'v', 'i' }, "<M-v>", "<Esc>:Telescope neoclip<CR>", { noremap = true, silent = true })


		require('neoclip').setup({
			history = 1000,
			enable_persistent_history = true,
			length_limit = 1048576,
			continuous_sync = true,
			db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
			filter = nil,
			preview = true,
			prompt = nil,
			default_register = '"',
			default_register_macros = 'q',
			enable_macro_history = true,
			content_spec_column = false,
			disable_keycodes_parsing = false,
			dedent_picker_display = false,
			initial_mode = 'insert',
			on_select = {
				move_to_front = false,
				close_telescope = true,
			},
			on_paste = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_replay = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_custom_action = {
				close_telescope = true,
			},
			keys = {
				telescope = {
					i = {
						select = '<cr>',
						paste = '<c-p>',
						paste_behind = '<c-k>',
						replay = '<c-q>',  -- replay a macro
						delete = '<c-d>',  -- delete an entry
						edit = '<c-e>',  -- edit an entry
						custom = {},
					},
					n = {
						select = '<cr>',
						paste = 'p',
						--- It is possible to map to more than one key.
						-- paste = { 'p', '<c-p>' },
						paste_behind = 'P',
						replay = 'q',
						delete = 'd',
						edit = 'e',
						custom = {},
					},
				},
				fzf = {
					select = 'default',
					paste = 'ctrl-p',
					paste_behind = 'ctrl-k',
					custom = {},
				},
			},
		})
	end,
}
