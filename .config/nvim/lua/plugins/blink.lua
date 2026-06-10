return {
	"saghen/blink.cmp",
	version = "*",
	opts = {
		keymap = {
			preset = "default",
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		completion = {
			accept = { auto_brackets = { enabled = true } },
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
			ghost_text = { enabled = false },
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
		},
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
