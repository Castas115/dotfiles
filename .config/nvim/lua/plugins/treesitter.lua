return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

		local parsers = {
			"go", "lua", "python", "rust", "typescript", "regex", "php", "bash",
			"markdown", "markdown_inline", "kdl", "sql", "terraform",
			"html", "css", "javascript", "yaml", "json", "toml", "nu",
			"git_config", "git_rebase", "gitattributes", "gitcommit",
		}

		local installed = ts.get_installed and ts.get_installed() or {}
		local set = {}
		for _, p in ipairs(installed) do set[p] = true end
		local missing = {}
		for _, p in ipairs(parsers) do
			if not set[p] then missing[#missing + 1] = p end
		end
		if #missing > 0 then ts.install(missing) end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("ts_highlight_indent", { clear = true }),
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				local lang = vim.treesitter.language.get_lang(ft)
				if not lang then return end
				local ok = pcall(vim.treesitter.start, args.buf, lang)
				if ok then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
	dependencies = {
		{ "nushell/tree-sitter-nu" },
	},
}
