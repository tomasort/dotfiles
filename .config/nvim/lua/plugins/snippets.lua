return {
	{ "rafamadriz/friendly-snippets" },
	{
		"mattn/emmet-vim",
		init = function()
			vim.g.user_emmet_leader_key = "<C-y>"
		end,
	},
}
