return {
	{
		"stevearc/conform.nvim",
		-- Load before any save so conform's BufWritePre autocmd (format_on_save)
		-- exists; also lazy-loads on first <leader>cf press
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format()
				end,
				desc = "Conform: Format file",
			},
		},
		opts = {

			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			notify_on_error = true,
			notify_no_formatters = true,
		},
	},
}
