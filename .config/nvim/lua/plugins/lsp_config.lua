return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			build = function()
				pcall(vim.cmd, "MasonUpdate")
			end,
		},
		{ "williamboman/mason-lspconfig.nvim" },
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "L3MON4D3/LuaSnip" },
		{ "saadparwaiz1/cmp_luasnip" },
	},
	config = function()
		-- First, let's verify lspconfig is working
		local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
		if not lspconfig_ok then
			vim.notify("LSPConfig failed to load!", vim.log.levels.ERROR)
			return
		end

		-- Setup Mason first
		require("mason").setup()

		-- Wait a bit and then setup mason-lspconfig
		vim.defer_fn(function()
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls", "lua_ls", "rust_analyzer" },
			})
		end, 100)

		-- Basic capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Key mappings
		local on_attach = function(client, bufnr)
			local set_keymap = function(mode, keymap, func, desc)
				vim.keymap.set(mode, keymap, func, { buffer = bufnr, remap = false, desc = desc })
			end

			set_keymap("n", "K", vim.lsp.buf.hover, "LSP Hover")
			set_keymap("n", "<leader>ld", vim.lsp.buf.definition, "Definition")
			set_keymap("n", "<leader>lr", vim.lsp.buf.references, "References")
			set_keymap("n", "<leader>la", vim.lsp.buf.code_action, "Code Action")
			set_keymap("n", "<leader>ln", vim.lsp.buf.rename, "Rename")
			set_keymap("n", "L", vim.diagnostic.setloclist, "Show Diagnostics")
			set_keymap("n", "<leader>ls", vim.lsp.buf.workspace_symbol, "Workspace Symbol")
			set_keymap("i", "<A-h>", vim.lsp.buf.signature_help, "Signature Help")
			set_keymap("n", "<leader>li", function ()
				vim.lsp.buf.code_action({
					apply = true,
					context = { diagnostics = {}, only = { "source.organizeImports" } },
				})
			end, "Organize Imports")
		end

		-- Manual server setup (bypass mason-lspconfig for now)
		local servers = {
			gopls = {},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
						telemetry = { enable = false },
					},
				},
			},
			rust_analyzer = {},
		}

		-- Setup servers manually
		for server, config in pairs(servers) do
			config.on_attach = on_attach
			config.capabilities = capabilities

			-- Try to setup each server
			local setup_ok, _ = pcall(lspconfig[server].setup, config)
			if not setup_ok then
				vim.notify("Failed to setup " .. server, vim.log.levels.WARN)
			end
		end

		-- Basic completion setup
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
		})

		-- Debug info
		vim.api.nvim_create_user_command("LspDebug", function()
			print("Available servers:", vim.inspect(vim.tbl_keys(lspconfig)))
			print("Active clients:", vim.inspect(vim.lsp.get_active_clients()))
		end, {})
	end,
}
