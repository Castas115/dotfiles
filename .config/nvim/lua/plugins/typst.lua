return {
	{
		"chomosuke/typst-preview.nvim",
		lazy = false,
		version = "1.*",
		config = function()
			require("typst-preview").setup({
				-- Use system binaries from Nix instead of downloaded ones
				dependencies_bin = {
					["tinymist"] = "tinymist",
					["websocat"] = "websocat",
				},
				open_cmd = "xdg-open %s",
				follow_cursor = true,
				invert_colors = "auto",
			})
			vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreview<cr>", { desc = "Typst Preview" })
		end,
	},
}
