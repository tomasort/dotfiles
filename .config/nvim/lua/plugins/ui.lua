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
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }

			-- Hide the *first* indent level's guide (the one hugging the
			-- gutter); levels 2+ still show their bars. The WHITESPACE hook
			-- gets the per-column whitespace cells ibl is about to render.
			-- Space-indent guides are INDENT cells; tab-indented buffers
			-- render theirs as TAB_START / TAB_START_SINGLE instead, so both
			-- get blanked (the first guide-rendering cell only).
			local IBL_WS = require("ibl.indent").whitespace
			local guide_cells = { [IBL_WS.INDENT] = true, [IBL_WS.TAB_START] = true, [IBL_WS.TAB_START_SINGLE] = true }
			hooks.register(hooks.type.WHITESPACE, function(_, _, _, whitespace)
				for i, cell in ipairs(whitespace) do
					if guide_cells[cell] then
						whitespace[i] = IBL_WS.SPACE
						break
					end
				end
				return whitespace
			end)

			require("ibl").setup({
				indent = {
					char = "▏",
				},
				scope = {
					enabled = false,
					show_end = false,
					highlight = highlight,
					include = {
						node_type = {
							python = {
								"class_definition",
								"function_definition",
								"for_statement",
								"while_statement",
								"if_statement",
								"try_statement",
								"with_statement",
							},
							javascript = {
								"class_definition",
								"function_definition",
								"for_statement",
								"while_statement",
								"if_statement",
								"try_statement",
								"return_statement",
							},
							typescript = {
								"class_definition",
								"function_definition",
								"for_statement",
								"while_statement",
								"if_statement",
								"try_statement",
								"return_statement",
							},
							html = { "tag" },
							yaml = { "block" },
							lua = {
								"function_definition",
								"for_statement",
								"while_statement",
								"if_statement",
								"try_statement",
								"return_statement",
								"table_constructor",
							},
						},
					},
				},
			})

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},
}
