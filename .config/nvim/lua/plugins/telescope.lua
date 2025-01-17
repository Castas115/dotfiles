return { 
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x', 
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()

			vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "[S]earch [K]ey maps" })
			vim.keymap.set("n", "<S-h>", function()
				require("telescope.builtin").buffers(require("telescope.themes").get_ivy({
					sort_mru = true,
					sort_lastused = true,
					initial_mode = "normal",
					-- Pre-select the current buffer
					-- ignore_current_buffer = false,
					-- select_current = true,
					layout_config = {
						preview_width = 0.6,
					},
				}))
			end, { desc = "Open telescope buffers" })
		end,
		keys = {
			{
				"<leader>fF",
				function()
					-- Get the directory of the currently active buffer
					local cwd = require("telescope.utils").buffer_dir()
					-- Use Telescope's find_files with a specific cwd
					require("telescope.builtin").find_files(require("telescope.themes").get_ivy({
						cwd = cwd,
						prompt_title = "Files in " .. cwd,
					}))
				end,
				desc = "Find Files (Buffer Dir)",
			},

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

			-- { "<leader>sg", LazyVim.pick("live_grep", { root = false, theme = "ivy" }), desc = "Grep (Root Dir)" },
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

			-- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
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
}

