return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { 
					"lua_ls",
					"gopls",
				}
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				-- capabilities = capabilities
			})
			lspconfig.gopls.setup({
				cmd = {"gopls"},
				filetyes = {"go", "gomod", "gowork", "gompl"},
				root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc="uwu"})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
			vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, {})
		end,
	},
}
