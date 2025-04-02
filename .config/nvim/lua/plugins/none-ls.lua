return {
	"nvimtools/none-ls.nvim",
	config = function()
		vim.keymap.set("n", "<leader>=", vim.lsp.buf.format, { desc = "Format file" })

		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.completion.spell,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.completion.eslint_d,
			},
		})
	end,
}
