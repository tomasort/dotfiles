return {
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	config = function()
	-- 		local highlight = {
	-- 			"RainbowRed",
	-- 			"RainbowYellow",
	-- 			"RainbowBlue",
	-- 			"RainbowOrange",
	-- 			"RainbowGreen",
	-- 			"RainbowViolet",
	-- 			"RainbowCyan",
	-- 		}
	--
	-- 		local hooks = require("ibl.hooks")
	-- 		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	-- 			vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	-- 			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	-- 			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	-- 			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	-- 			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	-- 			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	-- 			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
	-- 		end)
	--
	-- 		vim.g.rainbow_delimiters = { highlight = highlight }
	--
	-- 		-- Hide the *first* indent level's guide (the one hugging the
	-- 		-- gutter); levels 2+ still show their bars. The WHITESPACE hook
	-- 		-- gets the per-column whitespace cells ibl is about to render.
	-- 		-- Space-indent guides are INDENT cells; tab-indented buffers
	-- 		-- render theirs as TAB_START / TAB_START_SINGLE instead, so both
	-- 		-- get blanked (the first guide-rendering cell only).
	-- 		local IBL_WS = require("ibl.indent").whitespace
	-- 		local guide_cells = { [IBL_WS.INDENT] = true, [IBL_WS.TAB_START] = true, [IBL_WS.TAB_START_SINGLE] = true }
	-- 		hooks.register(hooks.type.WHITESPACE, function(_, _, _, whitespace)
	-- 			for i, cell in ipairs(whitespace) do
	-- 				if guide_cells[cell] then
	-- 					whitespace[i] = IBL_WS.SPACE
	-- 					break
	-- 				end
	-- 			end
	-- 			return whitespace
	-- 		end)
	--
	-- 		require("ibl").setup({
	-- 			indent = {
	-- 				char = "▏",
	-- 			},
	-- 			scope = {
	-- 				enabled = false,
	-- 				show_end = false,
	-- 				highlight = highlight,
	-- 				include = {
	-- 					node_type = {
	-- 						python = {
	-- 							"class_definition",
	-- 							"function_definition",
	-- 							"for_statement",
	-- 							"while_statement",
	-- 							"if_statement",
	-- 							"try_statement",
	-- 							"with_statement",
	-- 						},
	-- 						javascript = {
	-- 							"class_definition",
	-- 							"function_definition",
	-- 							"for_statement",
	-- 							"while_statement",
	-- 							"if_statement",
	-- 							"try_statement",
	-- 							"return_statement",
	-- 						},
	-- 						typescript = {
	-- 							"class_definition",
	-- 							"function_definition",
	-- 							"for_statement",
	-- 							"while_statement",
	-- 							"if_statement",
	-- 							"try_statement",
	-- 							"return_statement",
	-- 						},
	-- 						html = { "tag" },
	-- 						yaml = { "block" },
	-- 						lua = {
	-- 							"function_definition",
	-- 							"for_statement",
	-- 							"while_statement",
	-- 							"if_statement",
	-- 							"try_statement",
	-- 							"return_statement",
	-- 							"table_constructor",
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	-- 	end,
	-- },
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			indent = { char = "▏" }, -- default is ▎
			-- scope = { enabled = false }, -- default is true; keep or scope returns
		},
		config = function(_, opts)
			local hooks = require("ibl.hooks")
			-- Hide the first indent level's guide (the one hugging the
			-- gutter); levels 2+ still show. Space-indented guides are
			-- INDENT cells; tabs render as TAB_START[_SINGLE] instead.
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
			require("ibl").setup(opts)
		end,
	},
}
