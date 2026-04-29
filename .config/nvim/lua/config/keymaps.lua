local map = vim.keymap.set

map("n", "<leader>pv", "<Cmd>bel vsplit<CR><Cmd>Oil<CR>")
map("n", "<leader>ph", "<Cmd>bel split<CR><Cmd>Oil<CR>")
map("n", "-", "<Cmd>Oil<CR>")

map("n", "<leader>pi", "<Cmd>Lazy install<CR>")
map("n", "<leader>pc", "<Cmd>Lazy clean<CR>")
map("n", "<leader>pu", "<Cmd>Lazy update<CR>")

map("n", "<leader>td", "<Cmd>TodoTelescope keywords=TODO,FIX<CR>")

map("n", "<C-p>", "<Cmd>GFiles<CR>")
map("n", "<leader>pf", "<Cmd>Files<CR>")
map("n", "<leader>r", "<Cmd>Rg<CR>")
map("n", "<leader>tf", "<Cmd>Telescope find_files<CR>")
map("n", "<leader>tg", "<Cmd>Telescope live_grep<CR>")
map("n", "<leader>fb", "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>")
map("n", "<leader>b", "<Cmd>Telescope buffers<CR>")

map("n", "<leader>gs", "<Cmd>Git<CR>")
map("n", "<leader>gl", "<Cmd>GcLog<CR>")
map("n", "<leader>gP", "<Cmd>Git push<CR>")
map("n", "<leader>gp", "<Cmd>Git pull<CR>")
map("n", "<leader>ga", "<Cmd>Gwrite<CR>")
map("n", "<leader>gg", "<Cmd>LazyGit<CR>")
map("n", "<leader>u", "<Cmd>UndotreeToggle<CR>")
map("n", "<leader>cc", "<Cmd>CopilotChat<CR>")

map("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>")
map("n", "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>")
map("n", "<leader>cs", "<Cmd>Trouble symbols toggle focus=false<CR>")
map("n", "<leader>cl", "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>")
map("n", "<leader>xL", "<Cmd>Trouble loclist toggle<CR>")
map("n", "<leader>xQ", "<Cmd>Trouble qflist toggle<CR>")