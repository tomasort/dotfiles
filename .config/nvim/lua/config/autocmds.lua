vim.opt.conceallevel = 0
vim.opt.inccommand = "split"

-- require("config.filetypes")
-- require("config.dadbod")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("user_highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("oil_directory_open", { clear = true }),
  callback = function()
    local path = vim.fn.argv(0)
    if path ~= "" and vim.fn.isdirectory(path) == 1 then
      vim.cmd("Oil " .. vim.fn.fnameescape(path))
    end
  end,
})

-- Don't auto-continue comments: stops inserting the comment prefix on
-- <CR> ("r"), on o/O ("o"), and auto-wrapping inside comments ("c").
-- BufWinEnter (not just FileType) because some runtime plugins re-set
-- 'formatoptions' after FileType fires.
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o", "c" })
  end,
})
