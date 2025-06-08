return {
	"augmentcode/augment.vim",
	config = function()
		vim.g.augment_workspace_folders = {
			"/home/j.castander/dotfiles/.config",
			"/home/j.castander/salto_gh/pricebook.saltosystems.com",
			"/home/j.castander/programming/goEcon/",
			"/home/j.castander/programming/service-pattern-go/",
		}

		vim.keymap.set({"n", "v"}, "<leader>aa", "<cmd>Augment chat<cr>", { desc = "[A]ugment chat" })
		vim.keymap.set({"n", "v"}, "<leader>at", "<cmd>Augment chat-toggle<cr>", { desc = "[A]ugment chat toggle" })
	end,
}
