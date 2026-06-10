return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			dir_path = "assets",
			relative_to_current_file = true,
			prompt_for_file_name = false,
			file_name = "%Y-%m-%d-%H-%M-%S",
			use_absolute_path = false,
			extension = "png",
			show_dir_path_in_prompt = false,
		},
		filetypes = {
			markdown = {
				template = "![$CURSOR]($FILE_PATH)",
				url_encode_path = true,
			},
		},
	},
	keys = {
		{
			"<A-v>",
			function()
				if require("img-clip").paste_image() then return end
				local text = vim.fn.getreg("+")
				if text ~= "" then
					vim.api.nvim_paste(text, false, -1)
				end
			end,
			mode = { "n", "i" },
			desc = "Smart paste (image or text)",
		},
	},
}
