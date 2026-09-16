return {
	"sudo-tee/opencode.nvim",
	config = function()
		require("opencode").setup({})
	end,
	dependencies = {
		-- NOTE: disabled here and moved to plugins/markdown.lua instead —
		-- keep the opencode_output/file_types overrides below if ever needed
		-- here again; the AI-buffer config differs from the markdown.lua spec.
		-- Optional, for file mentions and commands completion, pick only one
		-- (configured in plugins/blink-cmp.lua; listed by name so it loads
		-- whenever opencode needs input-window completion)
		"saghen/blink.cmp",
		-- 'hrsh7th/nvim-cmp',

		-- Optional, for file mentions picker and floating prompt windows, pick only one
		{
			"folke/snacks.nvim",
		},
		-- 'nvim-telescope/telescope.nvim',
		-- 'ibhagwan/fzf-lua',
		-- 'nvim_mini/mini.nvim',
	},
}
