vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local vimrc = vim.fn.expand("~/.vimrc")

if vim.fn.filereadable(vimrc) == 1 then
	vim.cmd.source(vimrc)
end

-- Keep folds open by default in Neovim even though the shared .vimrc enables folding.
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Persistent undo history
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000

require("config.lazy")
require("config.keymaps")
require("config.autocmds")
