-- Dadbod and Dadbod UI configuration
local db_ui_auto_execute_table_helpers = 1

-- Set up dadbod-ui keymaps and autocmds
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbout",
  callback = function(event)
    vim.keymap.set("n", "o", ":DBOpen<CR>", { buffer = event.buf, noremap = true })
    vim.keymap.set("n", "A", ":DBAddConnection<CR>", { buffer = event.buf, noremap = true })
  end,
})

-- Setup vim-dadbod-ui appearance
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_force_echo_notifications = 0

-- Auto-execute table helpers (shows table structure and allows easy queries)
vim.g.db_ui_auto_execute_table_helpers = 1

-- Show notifications for operations
vim.g.db_ui_notification_width = 80

-- Optional: Configure custom buffer maps for SQL files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function(event)
    vim.keymap.set("n", "<leader>db", ":DBToggleDetails<CR>", { buffer = event.buf, noremap = true, silent = true })
    vim.keymap.set("n", "<leader>dq", ":DBQuery<CR>", { buffer = event.buf, noremap = true, silent = true })
    vim.keymap.set("n", "<leader>de", ":DBExecute<CR>", { buffer = event.buf, noremap = true, silent = true })
  end,
})

-- Enable vim-dadbod-completion for SQL files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.bo.omnifunc = "vim_dadbod_completion#omni"
  end,
})
