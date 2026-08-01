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
--
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", {desc = "Open Parent Directory in Oil"})
vim.keymap.set("n", "<leader>-v", "<Cmd>bel vsplit<CR><Cmd>Oil<CR>", {desc = "Open Oil in vertical split"})
vim.keymap.set("n", "<leader>-h", "<Cmd>bel split<CR><Cmd>Oil<CR>", {desc = "Open Oil in horizontal split" })

-- vim.keymap.set("n", "<leader><CR>", ":source ~/.config/nvim/init.lua<CR>", {desc = "Source config file" })
vim.keymap.set("n", "<leader><CR>", ":lua dofile(vim.fn.expand(\"~/.config/nvim/init.lua\"))<CR>", {desc = "Source config file" })

vim.keymap.set("n", "<leader>pi", "<Cmd>Lazy install<CR>", { desc = "Install plugins" })
vim.keymap.set("n", "<leader>pc", "<Cmd>Lazy clean<CR>", { desc = "Clean plugins" })
vim.keymap.set("n", "<leader>pu", "<Cmd>Lazy update<CR>", { desc = "Update plugins" })

vim.keymap.set("n", "<leader>gg", "<Cmd>LazyGit<CR>", { desc = "Open LazyGit" })

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
-- -- Git
-- vim.keymap.set("n", "<leader>gs", "<Cmd>Git<CR>", { desc = "Open Git status" })
-- vim.keymap.set("n", "<leader>gl", "<Cmd>GcLog<CR>", { desc = "Show Git log" })
-- vim.keymap.set("n", "<leader>gP", "<Cmd>Git push<CR>", { desc = "Push current branch" })
-- vim.keymap.set("n", "<leader>gp", "<Cmd>Git pull<CR>", { desc = "Pull current branch" })
-- vim.keymap.set("n", "<leader>ga", "<Cmd>Gwrite<CR>", { desc = "Stage current file" })
-- vim.keymap.set("n", "<leader>gv", "<Cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
-- vim.keymap.set("n", "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Show file history" })
-- vim.keymap.set("n", "<leader>gq", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>u", "<Cmd>UndotreeToggle<CR>", { desc = "Toggle undo tree" })
--
-- vim.keymap.set("n", "<leader>cf", "<Cmd>Format<CR>", { desc = "Format current buffer" })
-- vim.keymap.set("n", "<leader>af", "<Cmd>FormatToggle<CR>", { desc = "Toggle format on save" })
--
-- -- Diagnostics
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
-- vim.keymap.set("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics list" })
-- vim.keymap.set("n", "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Toggle buffer diagnostics" })
-- vim.keymap.set("n", "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>", { desc = "Toggle document symbols" })
-- vim.keymap.set("n", "<leader>cl", "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "Toggle LSP locations" })
-- vim.keymap.set("n", "<leader>xL", "<Cmd>Trouble loclist toggle<CR>", { desc = "Toggle location list" })
-- vim.keymap.set("n", "<leader>xQ", "<Cmd>Trouble qflist toggle<CR>", { desc = "Toggle quickfix list" })
