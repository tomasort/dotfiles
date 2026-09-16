return {
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", "<Cmd>LazyGit<CR>", desc = "Open LazyGit" },
		},
	},
	{ "tpope/vim-fugitive" },
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				vim.keymap.set("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { buffer = bufnr, desc = "Next git hunk" })
				vim.keymap.set("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { buffer = bufnr, desc = "Previous git hunk" })

				-- Hunk actions on <leader>g* lower-case (repo-level moved to
				-- <leader>G* ; see keymaps.lua Git section)
				vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
				vim.keymap.set("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { buffer = bufnr, desc = "Stage selected hunk" })
				vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
				vim.keymap.set("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { buffer = bufnr, desc = "Reset selected hunk" })
				vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
				vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
				vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
				vim.keymap.set(
					"n",
					"<leader>gi",
					gitsigns.preview_hunk_inline,
					{ buffer = bufnr, desc = "Preview hunk inline" }
				)
				vim.keymap.set("n", "<leader>gb", function()
					gitsigns.blame_line({ full = true })
				end, { buffer = bufnr, desc = "Blame line" })
				vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { buffer = bufnr, desc = "Diff against index" })
				vim.keymap.set("n", "<leader>gD", function()
					gitsigns.diffthis("@")
				end, { buffer = bufnr, desc = "Diff against last commit" })
				vim.keymap.set(
					"n",
					"<leader>gq",
					gitsigns.setqflist,
					{ buffer = bufnr, desc = "Populate quickfix with hunks" }
				)
				vim.keymap.set("n", "<leader>gQ", function()
					gitsigns.setqflist("all")
				end, { buffer = bufnr, desc = "Populate quickfix with repo hunks" })
			end,
		},
	},
}
