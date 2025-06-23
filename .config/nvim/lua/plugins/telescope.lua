return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = function()
			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")
			local extensions = require("telescope").extensions

			return {
				{
					"H",
					function()
						builtin.buffers(themes.get_ivy({
							sort_mru = true,
							sort_lastused = true,
							initial_mode = "normal",
							layout_config = { preview_width = 0.6 },
						}))
					end,
					desc = "List Buffers",
				},
				{
					"<leader>ff",
					function()
						local cwd = vim.fn.getcwd()
						extensions.frecency.frecency(themes.get_ivy({
							workspace = "CWD",
							cwd = cwd,
							prompt_title = "FRECENCY " .. cwd,
						}))
					end,
					desc = "Find Files (Root Dir)",
				},
				{
					"<leader>sg",
					function()
						local cwd = vim.fn.getcwd()
						builtin.live_grep(themes.get_ivy({
							cwd = cwd,
							prompt_title = "GREP " .. cwd,
						}))
					end,
					desc = "Grep in Root Dir",
				},
				{
					"<leader>sG",
					function()
						local cwd = require("telescope.utils").buffer_dir()
						builtin.live_grep(themes.get_ivy({
							cwd = cwd,
							prompt_title = "GREP " .. cwd,
						}))
					end,
					desc = "Grep in Buffer Dir",
				},
				{
					"<leader>fg",
					function()
						builtin.git_status(themes.get_ivy({
							layout_config = { preview_width = 0.6 },
							initial_mode = "normal",
						}))
					end,
					desc = "Git Status",
				},
				{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find Keymaps", },
				{ "<leader>fs", builtin.lsp_document_symbols, desc = "Find Symbols", },
				{ "<leader><leader>", "<cmd>e #<cr>", desc = "Alternate Buffer", },
			}
		end,
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					scroll_strategy = "limit",
					pickers = {
						find_files = {
							find_command = { "rg", "--files", "--sortr=modified" },
						},
					},
					path_display = {
						filename_first = {
							reverse_directories = true,
						},
					},
					mappings = {
						n = {
							["d"] = actions.delete_buffer,
							["q"] = actions.close,
							["<esc>"] = actions.close,
						},
					},
				},
			}
		end,
	},

	-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/telescope-frecency.lua
	-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/telescope-frecency.lua

	--[=====[
https://github.com/nvim-telescope/telescope-frecency.nvim

This plugins keeps a score of my recently access files through telescope, and
shows the ones I se the most at the top of the list

It requires telescope, so don't uninstall telescope

For questions read the docs
https://github.com/nvim-telescope/telescope-frecency.nvim/blob/master/doc/telescope-frecency.txt

You can delete entries from DB by this command. This command does not remove
the file itself, only from DB.
- delete the current opened file
  - :FrecencyDelete
- delete the supplied path
  - :FrecencyDelete /full/path/to/the/file
--]=====]

	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					frecency = {
						show_scores = true, -- Default: false
						-- If `true`, it shows confirmation dialog before any entries are removed from the DB
						-- If you want not to be bothered with such things and to remove stale results silently
						-- set db_safe_mode=false and auto_validate=true
						--
						-- This fixes an issue I had in which I couldn't close the floating
						-- window because I couldn't focus it
						db_safe_mode = false, -- Default: true
						-- If `true`, it removes stale entries count over than db_validate_threshold
						auto_validate = true, -- Default: true
						-- It will remove entries when stale ones exist more than this count
						db_validate_threshold = 10, -- Default: 10
						-- Show the path of the active filter before file paths.
						-- So if I'm in the `dotfiles-latest` directory it will show me that
						-- before the name of the file
						show_filter_column = false, -- Default: true
						-- I declare a workspace which I will use when calling frecency if I
						-- want to search for files in a specific path
						-- workspaces = {
						--   ["neobean_plugins"] = "$HOME/github/dotfiles-latest/neovim/neobean/lua/plugins",
						-- },
					},
				},
			})
			require("telescope").load_extension("frecency")
		end,
	},
}
