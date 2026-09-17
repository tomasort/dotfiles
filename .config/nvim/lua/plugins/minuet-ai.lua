return {
	{
		"milanglacier/minuet-ai.nvim",
		-- ghost-text completions; powers up on first insert
		event = "InsertEnter",
		config = function()
			require("minuet").setup({
				provider = "openai_compatible",
				request_timeout = 5,
				throttle = 1500, -- Increase to reduce costs and avoid rate limits
				debounce = 800, -- Increase to reduce costs and avoid rate limits
				-- OpenCode Zen's Go endpoint 400s ("MissingSessionID") unless the
				-- x-opencode-session header is present; minuet's openai_compatible
				-- backend can't add per-provider headers, so use the global
				-- curl-extra-args (only this provider is in use).
				curl_extra_args = { "-H", "x-opencode-session: nvim-minuet" },
				provider_options = {
					openai_compatible = {
						-- minuet treats this value as an ENV VAR NAME (exported in
						-- the git-ignored ~/.zshrc.local; sourced by ~/.zshrc)
						api_key = "OPENCODE_GO_API_KEY",
						end_point = "https://opencode.ai/zen/go/v1/chat/completions",
						model = "deepseek-v4.1-flash",
						name = "OpenCode",
						optional = {
							-- deepseek-style thinking disable; note glm models
							-- need `thinking = { type = "disabled" }` instead and
							-- will pump chain-of-thought text into the completion
							-- without it
							reasoning_effort = "none",
							max_tokens = 200,
							-- near-deterministic sampling for code completion
							-- (ghost-text): steer toward the maximum-probability
							-- token; less noise tail = fewer odd glyphs and relaxed
							-- suffix-breaking like duplicate closing brackets
							top_p = 0.35,
						},
					},
				},
				context_window = 16000,
				context_ratio = 0.75,
				virtualtext = {
					-- show the ghost text even while blink's completion menu is open
					-- (default was false, which hid it entirely)
					show_on_completion_menu = true,
					-- AUTOMATIC ghost text while typing (zen Go is cheap); minuet
					-- pulls the trigger per: debounce (600) + throttle (1500)
					-- between requests. Ignore ft list below adds a way out for
					-- noisy/scratch-like filetypes, add freely.
					auto_trigger_ft = { "*" },
					auto_trigger_ignore_ft = { "oil", "markdown", "gitcommit", "opencode", "lazygit" },
					-- minuet's own (unconditional) keymaps; fires only when a
					-- ghost suggestion is on screen, so plain typing is safe.
					keymap = {
						accept = "<C-g>", -- the WHOLE suggestion (tmux prefix is C-a!)
						-- NOTE: accept_line was also `<C-g>` (silent override:
						-- minuet maps accept then accept_line, so the *second*
						-- wins and C-g was doing line-by-line only). Line-by-line
						-- is nice for longer items; bind a distinct chord here if
						-- you want it (:: minuet accept action = whole, so C-g
						-- resolves to the whole suggestion now).
						accept_line = nil,
						next = "<C-j>", -- cycle next suggestion / manual invoke
						-- prev intentionally unbound: <C-k> goes back to blink's
						-- signature toggle; with few suggestions, <C-j> wraps
						-- around to cycle through them, so it's not needed
						prev = nil,
					},
				},
			})
			-- Because minuet loads on InsertEnter, buffers already open when
			-- setup runs never see minuet's FileType autocmd and stay without
			-- auto-trigger. Set the flag for them here (mirrors the plugin's
			-- own FileType callback at lua/minuet/virtualtext.lua).
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local ft = vim.bo[buf].filetype
				if ft ~= "" and not vim.tbl_contains({ "oil", "markdown", "gitcommit", "opencode", "lazygit" }, ft) then
					vim.b[buf].minuet_virtual_text_auto_trigger = true
				end
			end
		end,
	},
}
