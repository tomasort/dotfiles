return {
	{
		"folke/snacks.nvim",
		lazy = false,
		-- Without opts lazy.nvim only `require()`s snacks and never calls
		-- setup(), so its `input`/`picker` modules never override vim.ui.input
		-- and quick_chat prompts fall back to the plain command line.
		-- (Previously duplicated in lsp.lua + ai.lua as dependencies with the
		-- same opts; consolidated here — plain dependency strings there
		-- inherit this spec via lazy's opts merging.)
		opts = {
			input = { enabled = true },
			picker = { enabled = true },
		},
		keys = {
			{
				"<leader><space>",
				function()
					require("snacks").picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<leader>gl",
				function()
					require("snacks").lazygit.log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>es",
				function()
					require("snacks").explorer()
				end,
				desc = "Open Explorer",
			},
			{
				"<leader>rN",
				function()
					require("snacks").rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<leader>dB",
				function()
					require("snacks").bufdelete()
				end,
				desc = "Delete or Close Buffer (Confirm)",
			},
		},
	},
}
