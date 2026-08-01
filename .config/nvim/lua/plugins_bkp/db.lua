return {
	{
		"tpope/vim-dadbod",
		lazy = true,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.dbs = {}
		end,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-ui" },
		ft = { "sql", "mysql", "plsql" },
		init = function()
			-- Enable completion sources for dadbod
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					vim.bo.omnifunc = "vim_dadbod_completion#omni"
				end,
			})
		end,
	},
}
