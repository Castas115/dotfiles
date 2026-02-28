return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim" },  -- UI for LSP management
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "L3MON4D3/LuaSnip" },
		{ "saadparwaiz1/cmp_luasnip" },
	},
	config = function()
		-- Setup Mason (for UI only, LSPs installed via Nix)
		require("mason").setup()

		-- Capabilities for autocompletion
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Key mappings on LSP attach
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
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
				set_keymap("n", "<leader>li", function()
					vim.lsp.buf.code_action({
						apply = true,
						context = { diagnostics = {}, only = { "source.organizeImports" } },
					})
				end, "Organize Imports")
			end,
		})

		-- Neovim 0.11+ uses vim.lsp.config
		local servers = {
			"gopls",
			"rust_analyzer",
			"bashls",
			"pyright",
			"ts_ls",
			"html",
			"cssls",
			"jsonls",
			"yamlls",
			"dockerls",
			"terraformls",
			"taplo",
			"marksman",
			"nil_ls",
			"phpactor",
		}

		-- Configure all servers with default capabilities
		for _, server in ipairs(servers) do
			vim.lsp.config(server, { capabilities = capabilities })
		end

		-- Lua needs extra config
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					telemetry = { enable = false },
				},
			},
		})

		-- Enable all servers
		table.insert(servers, "lua_ls")
		vim.lsp.enable(servers)

		-- Completion setup
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
	end,
}
