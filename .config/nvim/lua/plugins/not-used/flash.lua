return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config

	opts = {
		labels = "jklfdsahgmvcxzuioprewqnbyt",
		-- modes = {
		-- 	search = {
		-- 		enabled = true,
		-- 	},
		-- },
	},
	-- stylua: ignore
	keys = {
		{ "<A-/>",   mode = { "n", "x", "o" }, function() require("flash").remote() end,     desc = "Remote Flash" },
		{ "<A-t>",   mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Treesitter" },
		-- { "<A-/>",   mode = { "n", "x", "o" }, function() require("flah").jump() end,              desc = "Flash" },
		-- { "<A-t>",       mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		-- { "<A-S-t>", mode = { "n", "x", "o" }, function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
		-- { "<A-w",    mode = { "n", "x", "o" }, function() require("flash").prompt() end,            desc = "Toggle Flash Search" },
	},
}
