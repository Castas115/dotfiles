return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		dapui.setup()

		require("nvim-dap-virtual-text").setup()
		require("dap-go").setup({
			-- Add configuration for Go debugging
			dap_configurations = {
				{
					type = "go",
					name = "Debug Package",
					request = "launch",
					mode = "test",
					program = "${fileDirname}",
					dlvToolPath = vim.fn.exepath("dlv"),
				},
			},
		})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>dd", dapui.toggle, { desc = "Debugger [d]" })
		vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debugger [b]reakpoint" })
		vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Debugger [c]ontinue" })
		vim.keymap.set(
			"n",
			"<Leader>dr",
			":lua require('dapui').open({reset = true})<CR>",
			{ desc = "Debugger [r]require ns" }
		)

		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "⏺", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
		)
	end,
}
