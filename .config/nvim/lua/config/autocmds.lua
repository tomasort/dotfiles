vim.opt.conceallevel = 0
vim.opt.inccommand = "split"

require("config.filetypes")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("user_highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = vim.api.nvim_create_augroup("oil_directory_open", { clear = true }),
--   callback = function()
--     local path = vim.fn.argv(0)
--     if path ~= "" and vim.fn.isdirectory(path) == 1 then
--       vim.cmd("Oil " .. vim.fn.fnameescape(path))
--     end
--   end,
-- })