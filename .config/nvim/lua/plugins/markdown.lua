-- In-buffer Markdown rendering + LaTeX equation display.
-- render-markdown.nvim owns the document structure (headings, lists,
-- tables, callouts, code block backgrounds) and renders with pure
-- extmarks/conceal so it works in ANY terminal (no image protocol needed).
return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		-- NOT ft: FileType events that fire before lazy's setup (e.g. nvim
		-- opened straight into a .md file) never trigger `ft` keys and the
		-- plugin stays in lazy's "Not Loaded" limbo. VeryLazy + the plugin's
		-- own file_types gating has no such race.
		event = "VeryLazy",
		opts = {
			-- let render-latex.nvim own equations (rendered as images);
			-- render-markdown's own inline latex preview is redundant
			latex = { enabled = false },
			code = {
				style = "normal",
				width = "full",
			},
			preset = "extended",
			file_types = { "markdown", "opencode_output", "Avante", "copilot-chat" },
		},
	},
	{
		-- Display-math renderer for $$ ... $$ blocks. Raw LaTeX stays in the
		-- buffer; only display blocks become inline images via the kitty
		-- graphics protocol (works in WezTerm/Kitty; replaces mdmath.nvim
		-- whose Unicode Placeholders hack WezTerm lacks). Inline math uses
		-- the fast conceal fallback. NOTE: bare :RenderLatex == toggle!
		-- use :RenderLatex enable/disable/toggle explicitly.
		"techwizrd/render-latex.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		opts = {
			-- iTerm2 >= 3.6 implements the kitty graphics protocol, but its
			-- TERM isn't on the plugin's auto-detect allowlist, and nested
			-- inside tmux the probe sees tmux rather than iTerm2 — so force
			-- the backend (doctor explicitly recommends this)
			image = { backend = "kitty" },
			-- install tmux hooks (session-window-changed, window-pane-changed,
			-- client-session-changed) that send the kitty-protocol DELETE
			-- sequence to the client tty on switch; otherwise images painted
			-- by nvim linger on screen after hopping tmux windows
			tmux = { install_cleanup_hooks = true },
			render = {
				preset = "match_text",
				-- rendered glyphs come out thin/skinny at the default 34px —
				-- bigger canvas font + uniform scale for crisp strokes
				font_size = 48,
				scale = 2.0,
				inline = "conceal",
				inline_symbols = true,
				live_preview = true,
			},
		},
		config = function(_, opts)
			require("render_latex").setup(opts)
			-- inline math conceal fallback needs these; set for markdown-ish
			-- buffers only so the rest of the editor keeps conceallevel 0
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("render_latex_md_conceal", {}),
				pattern = { "markdown", "opencode_output", "Avante", "copilot-chat" },
				callback = function()
					vim.opt_local.conceallevel = 2
					vim.opt_local.concealcursor = "nc"
				end,
			})
		end,
	},
}
