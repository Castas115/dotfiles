return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v2.x",
	dependencies = {
		-- LSP Support
		{ "neovim/nvim-lspconfig" }, -- Required
		{ -- Optional
			"williamboman/mason.nvim",
			build = function()
				pcall(vim.cmd, "MasonUpdate")
			end,
		},
		{ "williamboman/mason-lspconfig.nvim" }, -- Optional

		-- Autocompletion
		{ "hrsh7th/nvim-cmp" }, -- Required
		{ "hrsh7th/cmp-nvim-lsp" }, -- Required
		{ "L3MON4D3/LuaSnip" }, -- Required
		{ "rafamadriz/friendly-snippets" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "saadparwaiz1/cmp_luasnip" },
	},
	config = function()
		local lsp = require("lsp-zero")
		vim.diagnostic.config({
			virtual_text = true, -- Show diagnostics inline
			signs = true, -- Show signs in the gutter
			underline = true, -- Underline the error text
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = true,
			},
		})

		lsp.on_attach(function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }

			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))
			vim.keymap.set("n", "L", function()
				vim.diagnostic.setloclist()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Show Diagnostics" }))
			vim.keymap.set("n", "<leader>lr", function()
				vim.lsp.buf.references()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP References" }))
			vim.keymap.set("n", "<leader>ld", function()
				vim.lsp.buf.definition()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Definition" }))
			vim.keymap.set("n", "<leader>ln", function()
				vim.lsp.buf.rename()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }))
			vim.keymap.set("n", "<leader>la", function()
				vim.lsp.buf.code_action()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }))
			vim.keymap.set("n", "<leader>ls", function()
				vim.lsp.buf.workspace_symbol()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Workspace Symbol" }))
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
			vim.keymap.set("n", "<leader>li", function()
				vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
			end, vim.tbl_deep_extend("force", opts, { desc = "LSP Organize Imports" }))
		end)

		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"rust_analyzer",
				"lua_ls",
				"dockerls",
				"bashls",
				"marksman",
				"gopls",
			},
			handlers = {
				lsp.default_setup,
				lua_ls = function()
					local lua_opts = lsp.nvim_lua_ls()
					require("lspconfig").lua_ls.setup(lua_opts)
				end,
			},
		})

		local cmp_action = require("lsp-zero").cmp_action()
		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		require("luasnip.loaders.from_vscode").lazy_load()

		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- `:` cmdline setup.
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip", keyword_length = 2 },
				{ name = "buffer", keyword_length = 3 },
				{ name = "path" },
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-f>"] = cmp_action.luasnip_jump_forward(),
				["<C-b>"] = cmp_action.luasnip_jump_backward(),
				-- ["<Tab>"] = cmp_action.luasnip_supertab(),
				["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
			}),
		})
	end,
}
