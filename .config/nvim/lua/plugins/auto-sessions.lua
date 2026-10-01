return {
	{
		"rmagatti/auto-session",
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			-- log_level = 'debug',
			auto_restore_last_session = false,
		},
		keys = {
			{ "<leader>fs", "<CMD>AutoSession search<CR>", desc = "Search sessions" },
		},
	},
}
