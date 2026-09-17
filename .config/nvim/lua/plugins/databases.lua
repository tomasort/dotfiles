-- Databases: execute SQL (vim-dadbod), browse schema (vim-dadbod-ui) and get
-- table/column completion in sql buffers (vim-dadbod-completion, wired into
-- blink as the `dadbod` source in blink-cmp.lua).
--
-- Connection URL comes from the environment: DBUI_URL / DBUI_NAME exported in
-- the git-ignored ~/.zshrc.local (nothing hardcoded here).
--
-- Docker: the `dockerpg://` scheme (adapter in autoload/db/adapter/dockerpg.vim)
-- runs psql *inside* a running Postgres container, auto-detected by name/image
-- -- `dockerpg:///mydb` (or `dockerpg://container/mydb` to pick one explicitly).
-- A `docker` entry is registered below so it shows up in the explorer.

return {
	{
		"tpope/vim-dadbod",
		lazy = true,
		keys = {
			{ "<leader>qe", ":%DB<CR>", desc = "Run whole buffer as SQL" },
			{ "<leader>qe", "<Cmd>'<,'>DB<CR>", mode = "v", desc = "Run selection as SQL" },
		},
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			-- vim-dadbod-ui picks these up as explorer connections.
			if vim.fn.executable("docker") == 1 then
				vim.g.dbs = { { name = "docker (auto)", url = "dockerpg:///" } }
			end
		end,
		keys = {
			{ "<leader>qq", "<Cmd>DBUI<CR>", desc = "Open database explorer" },
			{ "<leader>qf", "<Cmd>DBUIFindBuffer<CR>", desc = "Find current buffer in db explorer" },
		},
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-ui" },
		ft = { "sql", "mysql", "plsql" },
		init = function()
			-- dadbod-completion completes objects of the connection bound to
			-- the *buffer* (b:db), else falls back to $DATABASE_URL (the
			-- opencode MCP's empty `postgres` db) → zero items. Bind sql
			-- buffers to the env connection so completion works out of the
			-- box; `:DB <url|name>` overrides per buffer.
			-- Registered in `init` (startup) rather than `config`: lazy runs
			-- `config` because of the first FileType event, too late to
			-- catch that very buffer.
			local url = vim.env.DBUI_URL
			local function bind(buf)
				if vim.b[buf].db == nil and url then
					vim.api.nvim_buf_set_var(buf, "db", url)
				end
			end
			vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
				pattern = { "sql", "mysql", "plsql" },
				callback = function(ev) bind(ev.buf) end,
			})
			-- buffers opened before lazy finished loading
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						bind(buf)
					end
				end,
			})
		end,
	},
}
