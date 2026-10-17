vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local vimrc = vim.fn.expand("~/.vimrc")

if vim.fn.filereadable(vimrc) == 1 then
	vim.cmd.source(vimrc)
end

-- Keep folds open by default in Neovim even though the shared .vimrc enables folding.
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Python provider (pynvim) lives in the jupyter venv; required for
-- remote plugins like molten-nvim.
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/jupyter/bin/python")

-- Persistent undo history
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.showmode = false
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000

require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("remote")
