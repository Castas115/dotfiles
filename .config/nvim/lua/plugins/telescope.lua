return {
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[F]ind [K]ey maps" })
			vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find Symbols" })
			vim.keymap.set("n", "<leader>fd", function()
				require("telescope.builtin").buffers(require("telescope.themes").get_ivy({
					sort_mru = true,
					sort_lastused = true,
					initial_mode = "normal",
					layout_config = {
						preview_width = 0.6,
					},
				}))
			end, { desc = "Open telescope buffers" })
		end,
		keys = {
			{
				"<leader>ff",
				function()
					local cwd = vim.fn.getcwd()
					require("telescope").extensions.frecency.frecency(require("telescope.themes").get_ivy({
						workspace = "CWD",
						cwd = cwd,
						prompt_title = "FRECENCY " .. cwd,
					}))
				end,
				desc = "Find Files (Root Dir)",
			},
			-- { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (cwd)" },
			{
				"<leader>sG",
				function()
					local cwd = require("telescope.utils").buffer_dir()
					require("telescope.builtin").live_grep(require("telescope.themes").get_ivy({
						cwd = cwd,
						prompt_title = "GREP " .. cwd,
					}))
				end,
				desc = "[P]Grep (buffer dir)",
			},
			{
				"<leader>sg",
				function()
					local cwd = vim.fn.getcwd()
					require("telescope.builtin").live_grep(require("telescope.themes").get_ivy({
						-- gets current working directory
						cwd = cwd,
						prompt_title = "GREP " .. cwd,
					}))
				end,
				desc = "[P]Grep (Root Dir)",
			},

			{
				"<leader>gs",
				function()
					require("telescope.builtin").git_status(require("telescope.themes").get_ivy({
						layout_config = {
							-- Set preview width, 0.7 sets it to 70% of the window width
							preview_width = 0.7,
							-- height = 0.2,
						},
						initial_mode = "normal", -- Start in normal mode
					}))
				end,
				desc = "Git Status (ivy theme with custom preview size)",
			},

			{
				"<leader><leader>",
				"<cmd>e #<cr>",
				desc = "Alternate buffer",
			},

			{
				"<leader>tl",
				"<cmd>TodoTelescope keywords=TODO<cr>",
				desc = "[P]TODO list (Telescope)",
			},

			{
				"<leader>ta",
				"<cmd>TodoTelescope keywords=PERF,HACK,TODO,NOTE,FIX<cr>",
				desc = "[P]TODO list ALL (Telescope)",
			},
		},
		opts = function()
			return {
				defaults = {
					-- Prevents cycle cycling looping through results when reach the end
					-- The default value is "cycle"
					scroll_strategy = "limit",
					-- I'm adding this `find_command` based on this reddit discussion
					-- https://www.reddit.com/r/neovim/comments/1egczrs/comment/lfsotjx/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
					-- However, it doesn't work, also tried without the setup function
					require("telescope").setup({
						pickers = {
							find_files = {
								find_command = { "rg", "--files", "--sortr=modified" },
							},
						},
					}),
					-- When I search for stuff in telescope, I want the path to be shown
					-- first, this helps in files that are very deep in the tree and I
					-- cannot see their name.
					-- Also notice the "reverse_directories" option which will show the
					-- closest dir right after the filename
					path_display = {
						filename_first = {
							reverse_directories = true,
						},
					},
					mappings = {
						n = {
							-- I'm used to closing buffers with "d" from bufexplorer
							["d"] = require("telescope.actions").delete_buffer,
							-- I'm also used to quitting bufexplorer with q instead of escape
							["q"] = require("telescope.actions").close,
							["<esc>"] = require("telescope.actions").close,
						},
						-- -- When in insert mode, I want to quit telescope when I press escape
						-- -- instead of going to normal mode, to go to normal mode I can press
						-- -- my regular `kj`
						-- -- https://www.reddit.com/r/neovim/comments/1ghzlx4/comment/lv3jg0n/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
						-- i = {
						--   ["<esc>"] = require("telescope.actions").close,
						-- },
					},
				},
			}
		end
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
	}
}

