local function ts_move(action, capture)
	return function()
		require("nvim-treesitter-textobjects.move")[action](capture, "textobjects")
	end
end

local function ts_select(capture)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
	end
end


return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		branch = "main",
		config = function()
			require("config.treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Jump forward to the nearest match if cursor isn't inside one (targets.vim style)
					lookahead = true,
					selection_modes = {
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},
				},
				move = {
					set_jumps = true,
				},
			})
		end,
		keys = {
			-- Move
			{ "]m", ts_move("goto_next_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function start" },
			{ "[[", ts_move("goto_previous_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Previous class start" },
			{ "]]", ts_move("goto_next_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Next class start" },
			{ "[m", ts_move("goto_previous_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Previous function start" },
			{ "]M", ts_move("goto_next_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function end" },
			{ "[M", ts_move("goto_previous_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Previous function end" },
			{ "][", ts_move("goto_next_end", "@class.outer"), mode = { "n", "x", "o" }, desc = "Next class end" },
			{ "[]", ts_move("goto_previous_end", "@class.outer"), mode = { "n", "x", "o" }, desc = "Previous class end" },
			-- Select
			{ "af", ts_select("@function.outer"), mode = { "x", "o" }, desc = "a function" },
			{ "if", ts_select("@function.inner"), mode = { "x", "o" }, desc = "inner function" },
			{ "ac", ts_select("@class.outer"), mode = { "x", "o" }, desc = "a class" },
			{ "ic", ts_select("@class.inner"), mode = { "x", "o" }, desc = "inner class" },
			{ "aa", ts_select("@parameter.outer"), mode = { "x", "o" }, desc = "a parameter" },
			{ "ia", ts_select("@parameter.inner"), mode = { "x", "o" }, desc = "inner parameter" },
			-- Swap
			{ "<leader>a", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, desc = "Swap next parameter" },
			{ "<leader>A", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
			end, desc = "Swap previous parameter" },
			-- Repeatable move: repeat last textobject jump with ; and ,
			-- and keep builtin f/F/t/T repeats working
			{ ";", function()
				require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_next()
			end, mode = { "n", "x", "o" }, desc = "Repeat last textobject move (next)" },
			{ ",", function()
				require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_previous()
			end, mode = { "n", "x", "o" }, desc = "Repeat last textobject move (previous)" },
			{ "f", function()
				return require("nvim-treesitter-textobjects.repeatable_move").builtin_f_expr()
			end, mode = { "n", "x", "o" }, expr = true },
			{ "F", function()
				return require("nvim-treesitter-textobjects.repeatable_move").builtin_F_expr()
			end, mode = { "n", "x", "o" }, expr = true },
			{ "t", function()
				return require("nvim-treesitter-textobjects.repeatable_move").builtin_t_expr()
			end, mode = { "n", "x", "o" }, expr = true },
			{ "T", function()
				return require("nvim-treesitter-textobjects.repeatable_move").builtin_T_expr()
			end, mode = { "n", "x", "o" }, expr = true },
		},
	},
}
