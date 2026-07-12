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
				local paths = { vim.fn.getcwd() }
				for i = 0, vim.fn.argc() - 1 do
					paths[#paths + 1] = vim.fn.fnamemodify(vim.fn.argv(i), ":p")
				end
				for _, p in ipairs(paths) do
					if p:match("^/tmp/claude%-%d+") then
						return require("persistence").stop()
					end
				end
				if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
					require("persistence").load()
				end
			end,
			nested = true,
		})
	end,
}
