return {
	"MagicDuck/grug-far.nvim",
	opts = { headerMaxWidth = 80 },
	cmd = "GrugFar",
	keys = {
		{
			"<leader>sr",
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.toggle_instance({
					instanceName = "main",
					staticTitle = "Find and Replace",
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace (toggle)",
		},
	},
	config = function(_, opts)
		require("grug-far").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function(args)
				local map_opts = { buffer = args.buf, silent = true, desc = "Hide grug-far" }
				vim.keymap.set("n", "q", "<cmd>close<CR>", map_opts)
			end,
		})
	end,
}
