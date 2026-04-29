local vimrc = vim.fn.expand("~/.vimrc")

if vim.fn.filereadable(vimrc) == 1 then
  vim.cmd.source(vimrc)
end
local vimrc = vim.fn.expand("~/.vimrc")

if vim.fn.filereadable(vimrc) == 1 then
  vim.cmd.source(vimrc)
end

require("config.lazy")
require("config.keymaps")
require("config.autocmds")