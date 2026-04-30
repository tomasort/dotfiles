vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local vimrc = vim.fn.expand("~/.vimrc")

if vim.fn.filereadable(vimrc) == 1 then
  vim.cmd.source(vimrc)
end

require("config.lazy")
require("config.keymaps")
require("config.autocmds")
