return {
	{
		"folke/snacks.nvim",
		lazy = false,
		-- Without opts lazy.nvim only `require()`s snacks and never calls
		-- setup(), so its `input`/`picker` modules never override vim.ui.input
		-- and quick_chat prompts fall back to the plain command line.
		-- (Previously duplicated in lsp.lua + ai.lua as dependencies with the
		-- same opts; consolidated here — plain dependency strings there
		-- inherit this spec via lazy's opts merging.)
		opts = {
			input = { enabled = true },
			picker = { enabled = true },
			-- Embedded images in markdown/html/latex buffers via the kitty
			-- graphics protocol (render-markdown.nvim deliberately does NOT
			-- draw images itself). Math is disabled because render-latex.nvim
			-- already renders $$..$$ — otherwise both would draw it.
			image = {
				enabled = true,
				math = { enabled = false },
			},
		},
		init = function()
			-- snacks' terminal allowlist has no iTerm2 entry, and under tmux
			-- it only sees TERM=screen-256color, so it would report
			-- "unsupported" and draw nothing. tmux allow-passthrough is
			-- already on, so the escape codes do reach iTerm2.
			-- NB: inline placement needs the U=1 unicode-placeholder
			-- extension; iTerm2's support for it is unverified. If images
			-- don't appear, drop this line and set `force = true` in
			-- opts.image instead — that falls back to a hover float, which
			-- needs only base kitty graphics (which render-latex already
			-- proves works here).
			vim.env.SNACKS_KITTY = "true"
		end,
		keys = {
			{
				"<leader><space>",
				function()
					require("snacks").picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<leader>gl",
				function()
					require("snacks").lazygit.log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>rN",
				function()
					require("snacks").rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<leader>dB",
				function()
					require("snacks").bufdelete()
				end,
				desc = "Delete or Close Buffer (Confirm)",
			},
		},
	},
}
