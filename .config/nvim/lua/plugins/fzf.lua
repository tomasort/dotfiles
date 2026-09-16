local function project_root()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
		return vim.uv.cwd()
	end
	-- Walk up from the current buffer to the nearest project root marker,
	-- fall back to the buffer's dir for unsaved/scratch files
	return vim.fs.root(bufname, {
		".git",
		-- C/C++
		"Makefile",
		"CMakeLists.txt",
		"meson.build",
		"compile_commands.json",
		-- Python
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		".venv",
		-- Go
		"go.mod",
		-- Generic project data files
		"package.json",
		"Cargo.toml",
		"composer.json",
		"pom.xml",
		"build.gradle",
		".project",
	}) or vim.fs.dirname(bufname)
end

return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "nvim-mini/mini.icons" },
		---@module "fzf-lua"
		---@type fzf-lua.Config|{}
		---@diagnostic disable: missing-fields
		opts = {
			keymap = {
				fzf = {
					-- Explicit (some fzf versions rely solely on their defaults,
					-- which can get lost with older binaries)
					["ctrl-n"] = "down",
					["ctrl-p"] = "up",
					-- keep README-default list scrolling on ctrl-f/b; fzf's own
					-- preview pane is 0-wide here (builtin previewer draws its
					-- preview in a separate Neovim float), so fzf-side
					-- preview-page binds would target the hidden pane
				},
				builtin = {
					-- Neovim-side keys for the builtin previewer float:
					-- ctrl-f / ctrl-b page through the PREVIEW (fzf's own
					-- preview is rendered 0-wide; these scroll the float).
					-- ctrl-o remains focus-preview for vim motions/search.
					["<C-o>"] = "focus-preview",
					["<C-f>"] = "preview-page-down",
					["<C-b>"] = "preview-page-up",
				},
			},
		},
		---@diagnostic enable: missing-fields
		config = function(_, opts)
			-- ctrl-h toggles hidden files in-flight: press inside
			-- files/live_grep to re-run the search with/without --hidden.
			-- NOTE: fzf-lua REPLACES the whole `actions` table when the user
			-- provides one, so merge the defaults in first or pickers lose
			-- their `enter`/file actions (this bit us).
			local fzf = require("fzf-lua")
			opts.actions = vim.tbl_deep_extend("force", fzf.defaults.actions, opts.actions or {})
			opts.actions.files["ctrl-h"] = {
				fn = require("fzf-lua.actions").toggle_hidden,
				reuse = true,
				header = false,
			}
			fzf.setup(opts)
		end,
		keys = {
			{
				"<leader>ff",
				function()
					require("fzf-lua").files({ cwd = project_root() })
				end,
				desc = "Find Files in project root",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find files in Neovim config directory",
			},
			{
				"<leader>fh",
				function()
					require("fzf-lua").help_tags()
				end,
				desc = "Search help",
			},
			{
				"<leader>fk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "Search keymaps",
			},
			{
				"<leader>fr",
				function()
					require("fzf-lua").resume()
				end,
				desc = "Resume last search",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").builtin()
				end,
				desc = "Search picker menu",
			},
			{
				"<leader>fC",
				function()
					require("fzf-lua").commands()
				end,
				desc = "Search commands",
			},
			{
				"<leader>fw",
				function()
					require("fzf-lua").grep_cword()
				end,
				desc = "Find current word",
			},
			{
				"<leader>fW",
				function()
					require("fzf-lua").grep_cWORD()
				end,
				desc = "Find current WORD",
			},
			{
				"<leader>fo",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = "Search recent files",
			},
			{
				"<leader>fd",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "Search diagnostics",
			},
			{
				"<leader>fD",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
				desc = "Search diagnostics",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep({ cwd = project_root(), hidden = true })
				end,
				desc = "Live grep in project root",
			},

			{
				"<leader>/",
				function()
					require("fzf-lua").lgrep_curbuf()
				end,
				desc = "Live grep the current buffer",
			},

			{
				"<leader>b",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Show buffers",
			},
			{
				"<leader>b",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Show buffers",
			},
			{
				"<leader>gd",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Show buffers",
			},
		},
	},
}
