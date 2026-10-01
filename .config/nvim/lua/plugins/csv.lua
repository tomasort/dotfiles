return {
	{
		-- Renders CSV/TSV as aligned columns with borders, live-editable;
		-- doesn't rewrite the file. Toggle with :CsvViewToggle.
		"hat0uma/csvview.nvim",
		opts = {},
		keys = {
			{ "<leader>cv", "<Cmd>CsvViewToggle<CR>", ft = { "csv", "tsv" }, desc = "Toggle CSV view" },
		},
	},
	-- { "chrisbra/csv.vim" },
}
