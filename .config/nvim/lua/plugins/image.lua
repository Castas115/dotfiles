return {
	"3rd/image.nvim",
	build = false,
	ft = { "markdown", "vimwiki", "norg" },
	opts = {
		backend = "kitty",
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = true,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				filetypes = { "markdown", "vimwiki" },
			},
		},
		max_width = 200,
		max_height = 25,
		max_height_window_percentage = 80,
		max_width_window_percentage = 80,
		window_overlap_clear_enabled = true,
		editor_only_render_when_focused = false,
	},
	config = function(_, opts)
		require("image").setup(opts)

		local group = vim.api.nvim_create_augroup("image_visual_clear", { clear = true })
		vim.api.nvim_create_autocmd("ModeChanged", {
			group = group,
			pattern = { "*:[vV\22]*" },
			callback = function() require("image").clear() end,
		})
		vim.api.nvim_create_autocmd("ModeChanged", {
			group = group,
			pattern = { "[vV\22]*:*" },
			callback = function()
				if vim.bo.filetype == "markdown" then
					vim.cmd("edit")
				end
			end,
		})
	end,
}
