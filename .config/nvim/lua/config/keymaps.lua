-- local builtin = require("telescope.builtin")
--
-- local function search_scope()
-- 	local current_file = vim.api.nvim_buf_get_name(0)
-- 	if current_file ~= "" then
-- 		return vim.fs.root(current_file, { ".git" }) or vim.fs.dirname(current_file)
-- 	end
--
-- 	return vim.fn.getcwd()
-- end

vim.keymap.set(
	"n",
	"<leader><CR>",
	"<Cmd>silent update<CR><Cmd>silent source %<CR>",
	{ desc = "Save and source current file" }
)

--
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "<leader>pi", "<Cmd>Lazy install<CR>", { desc = "Install plugins" })
vim.keymap.set("n", "<leader>pc", "<Cmd>Lazy clean<CR>", { desc = "Clean plugins" })
vim.keymap.set("n", "<leader>pu", "<Cmd>Lazy update<CR>", { desc = "Update plugins" })

-- Treesitter incremental selection (built-in Neovim 0.12)
vim.keymap.set({ "x" }, "[n", function()
	require("vim.treesitter._select").select_prev(vim.v.count1)
end, { desc = "Select previous treesitter node" })

vim.keymap.set({ "x" }, "]n", function()
	require("vim.treesitter._select").select_next(vim.v.count1)
end, { desc = "Select next treesitter node" })

vim.keymap.set({ "x", "o" }, "an", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "x", "o" }, "in", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostic in float window" })

-- <C-Space> works from NORMAL mode (first press selects the node under the
-- cursor) and each press in VISUAL mode grows the selection to the parent.
-- Terminal quirk: real <C-space> arrives as <C-@>/<Nul> in terminals.
local function ts_select_parent()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end
-- Legacy terminals send Ctrl+Space as the NUL byte (<C-@>); newer ones
-- (kitty protocol) send a distinct sequence nvim parses as <C-Space>. Bind
-- both to the same function; harmless overlap.
vim.keymap.set({ "n", "x", "o" }, "<C-@>", ts_select_parent, { desc = "Select node / grow to parent treesitter node" })
vim.keymap.set({ "n", "x", "o" }, "<C-Space>", ts_select_parent, { desc = "Select node / grow to parent treesitter node" })

-- (the old <leader>cf Format keymap lives in plugins/conform.lua now)

-- AI completion engine switcher (COMMENTED OUT: only minuet is in use for
-- now; copilot.lua is commented in plugins/copilot.lua as well. Uncomment
-- BOTH blocks to restore the engine picker).
-- local ENGINE_FILE = vim.fn.stdpath("state") .. "/completion_engine"
-- local ENGINE_CHOICES = { "minuet", "copilot", "off" }
--
-- local function completion_engine_set(choice)
-- 	if not choice then
-- 		return
-- 	end
-- 	-- Only touch already-loaded plugins: calling require() on a disabled one
-- 	-- would eager-load it just to turn it off.
-- 	if package.loaded["minuet.virtualtext"] then
-- 		if choice == "minuet" then
-- 			require("minuet.virtualtext").action.enable_auto_trigger()
-- 		else
-- 			require("minuet.virtualtext").action.disable_auto_trigger()
-- 		end
-- 	end
-- 	if package.loaded["copilot.command"] then
-- 		if choice == "copilot" then
-- 			-- attach() both starts the copilot language server when needed and
-- 			-- reattaches this buffer; NEVER use command.enable() here:
-- 			-- c.setup() -> existing_client:stop(true) re-kills the running
-- 			-- copilot client with SIGTERM (= the "exit code 143" nag)
-- 			require("copilot.command").attach({})
-- 		else
-- 			-- detach instead of disable: command.disable tears down the whole
-- 			-- copilot LSP client, which nvim logs as
-- 			-- "Client copilot quit with exit code 143"; detach is silent and
-- 			-- just stops suggestions for this buffer
-- 			require("copilot.command").detach()
-- 		end
-- 	end
--
-- 	local f = io.open(ENGINE_FILE, "w")
-- 	if f then
-- 		f:write(choice)
-- 		f:close()
-- 	end
-- 	vim.g.completion_engine = choice
-- 	vim.notify("Completion engine set to: " .. choice, vim.log.levels.INFO)
-- end
--
-- local function completion_engine_restore()
-- 	local f = io.open(ENGINE_FILE, "r")
-- 	local choice = f and f:read("*l") or "minuet"
-- 	if f then
-- 		f:close()
-- 	end
-- 	if vim.tbl_contains(ENGINE_CHOICES, choice) then
-- 		vim.g.completion_engine = choice
-- 		-- copilot is the only choice that needs proactively arming; minuet
-- 		-- lazy-loads itself on first insert, and both engines are manual-only.
-- 		if choice == "copilot" then
-- 			-- :Lazy user command only registers on `User VeryLazy` (after
-- 			-- VimEnter), so use lazy's Lua API instead of vim.cmd("Lazy load");
-- 			-- attach() (not enable()) avoids the SIGTERM on an existing client
-- 			require("lazy").load({ plugins = { "copilot.lua" } })
-- 			require("copilot.command").attach({})
-- 		end
-- 	else
-- 		vim.g.completion_engine = "minuet"
-- 	end
-- end
--
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	group = vim.api.nvim_create_augroup("user_completion_engine", { clear = true }),
-- 	callback = completion_engine_restore,
-- })
--
-- vim.keymap.set("n", "<leader>ai", function()
-- 	vim.ui.select(ENGINE_CHOICES, { prompt = "Completion engine" }, completion_engine_set)
-- end, { desc = "Select AI completion engine" })
--
-- vim.api.nvim_create_user_command("CompletionEngine", function(args)
-- 	completion_engine_set(args.args ~= "" and args.args or nil)
-- end, {
-- 	nargs = "?",
-- 	complete = function()
-- 		return ENGINE_CHOICES
-- 	end,
-- })

--

-- vim.keymap.set("n", "<leader>td", "<Cmd>TodoTelescope keywords=TODO,FIX<CR>", { desc = "Show TODO picker" })
-- vim.keymap.set("n", "<leader>th", "<Cmd>Telescope help_tags<CR>", { desc = "Search help" })
-- vim.keymap.set("n", "<leader>tk", "<Cmd>Telescope keymaps<CR>", { desc = "Search keymaps" })
-- vim.keymap.set("n", "<leader>tr", "<Cmd>Telescope resume<CR>", { desc = "Resume last search" })
-- vim.keymap.set("n", "<leader>tc", "<Cmd>Telescope commands<CR>", { desc = "Search commands" })
-- vim.keymap.set("n", "<leader>tf", "<Cmd>Telescope find_files<CR>", { desc = "Find files" })
-- vim.keymap.set("n", "<leader>tg", "<Cmd>Telescope live_grep<CR>", { desc = "Live grep" })
-- vim.keymap.set("n", "<leader>fb", "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "Open file browser" })
-- vim.keymap.set("n", "<leader>b", "<Cmd>Telescope buffers<CR>", { desc = "Show buffers" })

-- vim.keymap.set("n", "<C-p>", "<Cmd>GFiles<CR>", { desc = "Search git files" })
-- vim.keymap.set("n", "<leader>pf", "<Cmd>Files<CR>", { desc = "Search files" })
-- vim.keymap.set("n", "<leader>r", "<Cmd>Rg<CR>", { desc = "Search with ripgrep" })
-- vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
-- vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
-- vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
-- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
-- vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
-- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
-- vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
-- vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
-- vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files (\".\" for repeat)" })
-- vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
-- vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- vim.keymap.set("n", "<leader>sn", function()
-- 	builtin.find_files({ cwd = vim.fn.stdpath("config") })
-- end, { desc = "[S]earch [N]eovim files" })
--

-- Git (repo-level; gitsigns hunks live in g on <leader>g* lower-case keys,
-- see plugins/git.lua on_attach)
-- uppercase-away-from-hunks: fugitive + oddballs on <leader>G*
-- (gs/gp/go got taken over by gitsigns hunk actions)
vim.keymap.set("n", "<leader>Gs", "<Cmd>Git<CR>", { desc = "Open Git status" })
vim.keymap.set("n", "<leader>Gl", "<Cmd>GcLog<CR>", { desc = "Show Git log" })
vim.keymap.set("n", "<leader>Gp", "<Cmd>Git pull<CR>", { desc = "Pull current branch" })
vim.keymap.set("n", "<leader>gP", "<Cmd>Git push<CR>", { desc = "Push current branch" })
vim.keymap.set("n", "<leader>Gw", "<Cmd>Gwrite<CR>", { desc = "Stage current file" })
vim.keymap.set("n", "<leader>gv", "<Cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>gH", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Show file history" })
vim.keymap.set("n", "<leader>gX", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>u", "<Cmd>UndotreeToggle<CR>", { desc = "Toggle undo tree" })

--
-- vim.keymap.set("n", "<leader>cf", "<Cmd>Format<CR>", { desc = "Format current buffer" })
-- vim.keymap.set("n", "<leader>af", "<Cmd>FormatToggle<CR>", { desc = "Toggle format on save" })
--
-- -- Diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics list" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Toggle buffer diagnostics" }
)
vim.keymap.set("n", "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>", { desc = "Toggle document symbols" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<Cmd>Trouble lsp toggle focus=false win.position=right<CR>",
	{ desc = "Toggle LSP locations" }
)
vim.keymap.set("n", "<leader>xL", "<Cmd>Trouble loclist toggle<CR>", { desc = "Toggle location list" })
vim.keymap.set("n", "<leader>xQ", "<Cmd>Trouble qflist toggle<CR>", { desc = "Toggle quickfix list" })
