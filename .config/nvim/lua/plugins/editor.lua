return {
	{ "mbbill/undotree" },
	{
		"nmac427/guess-indent.nvim",
		opts = {},
	},
	{
		-- Modern fold UI: treesitter (fallback indent) fold ranges, a chevron
		-- fold column, and `K` to peek a folded region. ufo owns foldmethod —
		-- it ends up `manual` — so no foldmethod/foldexpr is set anywhere.
		-- foldlevel/foldlevelstart stay in init.lua.
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		-- Not lazy-loadable: ufo only attaches on BufWinEnter (no retroactive
		-- attach), so loading after the first buffer is already on screen
		-- leaves it unfolded until the next edit. It must be up first.
		lazy = false,
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldenable = true
			-- fillchars: down-chevron for open folds, right-chevron for closed
			-- (Nerd Font; written as codepoints so this file stays ASCII)
			local open, close = vim.fn.nr2char(0xf47c), vim.fn.nr2char(0xf460)
			vim.o.fillchars = ("eob: ,fold: ,foldopen:%s,foldsep: ,foldinner: ,foldclose:%s"):format(open, close)
		end,
		opts = {
			-- treesitter where a parser exists, ufo's own indent provider
			-- otherwise (so no language ends up unfoldable)
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
		keys = {
			-- built-in zR/zM only change foldlevel, which ufo keeps at 99;
			-- these APIs close/open the folds themselves
			{ "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
			{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
			{ "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
			{ "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds by kind" },
			{
				"K",
				function()
					if not require("ufo").peekFoldedLinesUnderCursor() then
						vim.lsp.buf.hover()
					end
				end,
				desc = "Peek fold (or LSP hover)",
			},
		},
	},
	{
		"lervag/vimtex",
		init = function()
			vim.g.tex_flavor = "latex"
			-- macOS PDF viewer: skim supports forward/inverse search
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_quickfix_mode = 0
			vim.g.tex_conceal = "abdmg"
		end,
		-- Buffer-local <leader>t* keys (which-key hint: uncomment
		-- `{ "<leader>t", group = "LaTeX" }` in whichkey.lua if wanted):
		--   tc compile toggle · tv view+forward-search · ti info
		--   tt outline/TOC · te stop compile · tx clean aux · tf errors
		keys = {
			{ "<leader>tc", "<Cmd>VimtexCompile<CR>", ft = { "tex", "latex" }, desc = "Vimtex toggle compile" },
			{ "<leader>tv", "<Cmd>VimtexView<CR>", ft = { "tex", "latex" }, desc = "Vimtex view PDF (Skim fwd-search)" },
			{ "<leader>ti", "<Cmd>VimtexInfo<CR>", ft = { "tex", "latex" }, desc = "Vimtex info" },
			{ "<leader>tt", "<Cmd>VimtexTocToggle<CR>", ft = { "tex", "latex" }, desc = "Vimtex TOC" },
			{ "<leader>te", "<Cmd>VimtexStop<CR>", ft = { "tex", "latex" }, desc = "Vimtex stop compile" },
			{ "<leader>tx", "<Cmd>VimtexClean<CR>", ft = { "tex", "latex" }, desc = "Vimtex clean aux files" },
			{ "<leader>tf", function()
				if vim.b.vimtex == nil then
					vim.notify("Vimtex: not a LaTeX document buffer", vim.log.levels.WARN)
				else
					vim.cmd("VimtexErrors")
				end
			end, ft = { "tex", "latex" }, desc = "Vimtex quickfix errors" },
		},
	},
	-- 	{
	-- 		"sindrets/diffview.nvim",
	-- 		dependencies = { "nvim-lua/plenary.nvim" },
	-- 		opts = {},
	-- 	},
	{
		-- split/join arguments (regions inside brackets separated by ',').
		-- Dot-repeatable in Normal mode, works in Visual mode, and handles
		-- nested brackets/quotes correctly via detect.exclude_regions.
		"nvim-mini/mini.splitjoin",
		opts = {
			mappings = {
				-- keymap preference: sk = split args, sj = join args;
				-- gS keeps the built-in "smart toggle" behavior
				toggle = "gS",
				split = "sk",
				join = "sj",
			},
		},
	},
	{
		"echasnovski/mini.surround",
		-- replaced tpope/vim-surround (same job, more transparent
		-- implementation). Defaults inherit mini's keymap prefix "s":
		--   sa	Add surroundings
		--   sd	Delete surroundings
		--   sr	Replace surroundings
		--   sf / sF	Find / Find all surroundings (also n/p variants)
		--   sn	Update n_lines (respects mini.ai context n)
		-- The object targets differ from vim-surround: quotes are ' and " and
		-- ` (also q = any quote-like), function calls are f, tags are t.
		opts = {
			-- 0 = no duration highlight flash after action, match vim-surround feel
			n_lines = 5,
			-- respect_selection_customization = false,
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		},
	},
	-- { "tpope/vim-commentary" },
	-- { "tpope/vim-repeat" },
	-- guess-indent.nvim handles indent detection; vim-sleuth is redundant
	{ "nvim-tree/nvim-web-devicons" },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				map_cr = true,
				enable_check_bracket_line = false,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
		end,
		keys = {
			{
				"<leader>ft",
				function()
					require("todo-comments.fzf").todo()
				end,
				desc = "Find TODO",
			},
			{
				"<leader>fT",
				function()
					require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
				end,
				desc = "Find TODO/FIX/FIXME",
			},
		},
	},
	{ "christoomey/vim-tmux-navigator" },
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
				per_filetype = {
					html = {
						enable_close = true,
					},
				},
			})
		end,
	},
}
