return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
	},
	init = function()
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("persistence_autoload", { clear = true }),
			callback = function()
				if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
					require("persistence").load()
				end
			end,
			nested = true,
		})
	end,
}
