return {
	{ "nvim-tree/nvim-web-devicons" },
	{
		"ayu-theme/ayu-vim",
		priority = 1001,
		config = function()
			vim.cmd.colorscheme("ayu")
			vim.g.ayucolor = "dark"
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#4d5c6d", bg = "NONE" })
			vim.api.nvim_set_hl(0, "NonText", { fg = "#2b3446", bg = "NONE" })
			vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#4d5c6d", bg = "NONE" })
			vim.api.nvim_set_hl(0, "Directory", { fg = "#9da9b7", bg = "NONE" })
			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#52749a", italic = true })
			vim.api.nvim_set_hl(0, "Visual", { bg = "#314365" })
		end,
	},
	{
		-- TODO: I think we can remove this plugin colorizer.lua since now in neovim 12 we apparently can do vim.lsp.document_color.enable(true, nil, {style = virtual')} or somethign like that
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			parsers = { css = true, names = { enable = false } },
			display = {
				mode = {
					-- [1] = "foreground",
					[1] = "virtualtext",
				},
				virtualtext = {
					char = "██ ",
					position = "after",
				},
			},
		},
	},
	{
		"nvzone/minty",
		config = function()
			require("minty").setup({})
		end,
	},
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/menu",
		lazy = true,
	},
	{ "nvzone/typr" },
}
