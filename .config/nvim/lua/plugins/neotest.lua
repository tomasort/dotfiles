-- neotest: test orchestration (run/watch/debug tests with results UI).
-- Complements nvim-dap: read keybinds note below — `ta` etc. fire from
-- neotest itself, no separate config file for the adapters.
return {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio", -- already a dap-ui dependency, reused
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim", -- neotest's update loop needs it
			-- language adapters (one per language you test in)
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-go",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						-- uv detects the venv per project; keep pytest since
						-- auto-detect already probes pyproject/pytest.ini
						runner = "pytest",
					}),
					require("neotest-go"),
				},
			})

			-- keybinds: <leader>t* is free globally (tex keys are ft-scoped)
			local map = vim.keymap.set
			map("n", "<leader>ta", function()
				require("neotest").summary.toggle()
			end, { desc = "Neotest toggle summary" })
			map("n", "<leader>tr", function()
				require("neotest").run.run()
			end, { desc = "Neotest run nearest test" })
			map("n", "<leader>tR", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end, { desc = "Neotest run file" })
			map("n", "<leader>tS", function()
				require("neotest").run.run({ suite = true })
			end, { desc = "Neotest run suite" })
			map("n", "<leader>td", function()
				require("neotest").run.run({ strategy = "dap" })
			end, { desc = "Neotest debug nearest test" })
			map("n", "<leader>tw", function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end, { desc = "Neotest watch (file)" })
		end,
	},
}
