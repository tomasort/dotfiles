return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		-- optional: provides snippets for the snippet source
		"rafamadriz/friendly-snippets",
		-- completion of CSS variables (requires ripgrep)
		"jdrupal-dev/css-vars.nvim",
		-- LaTeX symbol completion
		"erooke/blink-cmp-latex",
		-- Maven/Gradle dependency completion (requires curl)
		"Mestane/blink-cmp-deps",
	},
	build = function()
		-- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
		-- you can use `gb` in `:Lazy` to rebuild the plugin as needed
		require("blink.cmp").build():pwait()
	end,

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		keymap = {
			preset = "default",
			-- <CR> accepts ONLY when an item has been explicitly
			-- selected (Up/Down/<C-n>/<C-p>); otherwise falls through to a
			-- normal newline. Requires completion.list.selection.preselect
			-- = false below, else item #1 is always "selected" when the
			-- menu opens.
			["<CR>"] = {
				function(cmp)
					if cmp.is_menu_visible() and cmp.get_selected_item() ~= nil then
						return cmp.accept()
					end
				end,
				"fallback",
			},
		},

		appearance = {
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
			-- If ever the theme doesn't provide blink's highlights, fall back to
			-- the nvim-cmp highlight names most colorschemes support
			use_nvim_cmp_as_default = true,
		},

		completion = {
			menu = {
				-- Rounded FloatBorder: matches FloatingWindow/editor-wide borders
				border = "rounded",
				winblend = 0,
				max_height = 12,
				direction_priority = { "s", "n" }, -- prefer below cursor, fall back up
				draw = {
					-- Just a touch of extra breathing room around rows
					padding = { 0, 1 },
					components = {
						-- highlight the gap and text of an item with a distinct
						-- but subtle kind-tinted color
						kind_icon = {
							ellipsis = true,
							-- Tint label + icon by the kind's highlight color,
							-- subtle; standard blink recipe
							text = function(ctx)
								return " " .. ctx.kind_icon
							end,
							highlight = function(ctx)
								return {
									{ group = ctx.kind_hl, priority = 20000 },
								}
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true, -- vs doc-open: shows on selection
				auto_show_delay_ms = 250,
				window = {
					border = "rounded",
					max_width = 70,
					max_height = 15,
				},
			},
			ghost_text = { enabled = false },
		list = {
			selection = {
				-- don't auto-select item #1 when the menu opens; keeps <CR>
				-- mapping's "only accept after explicit selection" honest
				-- (<C-y> / select_and_accept still works on the first item)
				preselect = false,
			},
		},
		},
		-- The text of the documentation will use treesitter? via draw default
		signature = {
			enabled = true, -- shows parameter hints as you type function args
			window = { border = "rounded" },
		},

		-- (Default) list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "css_vars" },

			providers = {
				css_vars = {
					name = "css-vars",
					module = "css-vars.blink",
				},
				latex = {
					name = "Latex",
					module = "blink-cmp-latex",
					-- inserts unicode symbols; set true (or a function) to insert
					-- the latex command instead
					opts = { insert_command = false },
				},
				deps = {
					name = "Dependencies",
					module = "blink_deps",
					async = true,
				},
			},

			-- only offer the latex source in tex/latex buffers
			per_filetype = {
				tex = { "latex", "lsp", "path", "snippets", "buffer" },
				latex = { "latex", "lsp", "path", "snippets", "buffer" },
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"`
		-- See the fuzzy documentation for more information
		fuzzy = {
			implementation = "prefer_rust", -- Rust matcher with silent Lua fallback
		},
	},
}
