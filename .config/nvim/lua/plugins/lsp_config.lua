local is_nixos = vim.uv.fs_stat("/etc/NIXOS") ~= nil

return {
	"neovim/nvim-lspconfig",
	dependencies = vim.tbl_filter(function(d) return d ~= nil end, {
		not is_nixos and { "williamboman/mason.nvim" } or nil,
		not is_nixos and { "williamboman/mason-lspconfig.nvim" } or nil,
		{ "saghen/blink.cmp" },
	}),
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

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
						context = { diagnostics = {}, only = { "source.organizeImports" } },
					})
				end, "Organize Imports")
			end,
		})

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
			"tinymist",
		}

		for _, server in ipairs(servers) do
			vim.lsp.config(server, { capabilities = capabilities })
		end

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim", "Snacks", "MiniFiles", "MiniDiff" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					telemetry = { enable = false },
				},
			},
		})

		table.insert(servers, "lua_ls")

		if not is_nixos then
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})
		end

		local available = {}
		for _, server in ipairs(servers) do
			local cfg = vim.lsp.config[server]
			local cmd = cfg and cfg.cmd
			local bin = type(cmd) == "table" and cmd[1] or nil
			if not bin or vim.fn.executable(bin) == 1 then
				table.insert(available, server)
			end
		end
		vim.lsp.enable(available)
	end,
}
