vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.opt.conceallevel = 0

require("config.filetypes")

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})