" Simple configurations that would work also on regular vim
" -----------------------------------------------------------
syntax on               " enable syntax highlighting
set cursorline          " highlight the current line
set ruler             	" show line number in bar
set nobackup            " don't create pointless backup files; Use VCS instead
set autoread            " watch for file changes
set number              " show line numbers
set nu rnu              " show relative line numbers
set showcmd             " show selection metadata
set showmode            " show INSERT, VISUAL, etc. mode
set showmatch           " show matching brackets
set autoindent smartindent  " auto/smart indent
set smarttab            " better backspace and tab functionality
set scrolloff=8         " show at least 8 lines above/below
set formatoptions+=j    " Delete comment character when joining commented lines
set sidescrolloff=5
set mouse=a
set ruler
set laststatus=2
set ignorecase
set smartcase
set undofile
set undodir=~/.vim/undodir
set hls ic
set updatetime=50
set splitright
set signcolumn=yes


" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
autocmd BufReadPost,FileReadPost * normal zR
set foldmethod=indent
set foldnestmax=1
set foldlevelstart=99

filetype on             " enable filetype detection
filetype indent on      " enable filetype-specific indenting
filetype plugin on      " enable filetype-specific plugins

" column-width visual indication
" let &colorcolumn=join(range(81,999),",")
" highlight ColorColumn ctermbg=235 guibg=#001D2F

" tmt-autoabs and indenting
set autoindent          " auto indenting
set smartindent         " smart indenting
set expandtab           " spaces instead of tabs
set tabstop=4           " 2 spaces for tabs
set shiftwidth=4        " 2 spaces for indentation

" bells
set noerrorbells        " turn off audio bell
set visualbell          " but leave on a visual bell

" search
set hlsearch            " highlighted search results
set showmatch           " show matching bracket
set incsearch           " incremental search

" Color configurations
set termguicolors       " enable true colors support

" Remaps
" -----------------------------------------------------------
let mapleader = " "

" reload configuration file
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>:nohl<CR>

" make the current file executable
nnoremap <leader>x :!chmod +x %<CR>

" Redraw screen and remove search highlighting
nnoremap <leader>l :nohl<CR>

" Close the current buffer
nnoremap <leader>X :bd<CR>

" open netrw in new vertical window with pv and close it with the same pv
nnoremap <leader>pv :Vex!<CR>
nnoremap <leader>ph :Hex<CR>
autocmd filetype netrw noremap <buffer> <leader>pv :q<CR>
autocmd filetype netrw noremap <buffer> <leader>ph :q<CR>
" open netrw in the current window
nnoremap - :Ex<CR>
nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>

" TMUX Scripts from vim
nnoremap <silent> <C-s> :silent !tmux neww tmux-sessionizer<CR>
nnoremap <silent> <C-g> :silent !tmux neww tmux-gh-sessionizer<CR>

" ch script
" nnoremap <silent> <leader>ch :silent !tmux split-window -h cheeto<CR>

" remaps for quicklists
nnoremap <leader>P :cprevious<CR>
nnoremap <leader>N :cnext<CR>

" We can move code around when it is highlighted with J and K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" remaps to quickly paste from the system clipboard
vnoremap <leader>p "+p
nnoremap <leader>p "+p
vnoremap <leader>y "+y
nnoremap <leader>y "+y

" easily enter into window mode
nnoremap <leader>w <C-w>

" save with less keystrokes?
nnoremap <leader>W :w<CR>

" keep the selected word in the middle of the string
nnoremap n nzzzv
nnoremap N Nzzzv

" Search and replace the word under the cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" remap to make it easier to fold code in python at least
nnoremap <leader>fc zM
nnoremap <leader>fo zR
nnoremap <leader>o zo
nnoremap <leader>c zc



" REMAPS DEALING WITH PLUGINS
" -----------------------------------------------------------

" remaps for installing, cleaning and updating plugins
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>pu :PlugUpdate<CR>

" remap for showing TODOs
nnoremap <leader>td :TodoTelescope keywords=TODO,FIX<CR>

" Fuzzy Find files
" require fzf 
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>pf :Files<CR>
nnoremap <leader>r :Rg<CR>
" require telescope
nnoremap <leader>tf :Telescope find_files<CR>
nnoremap <leader>tg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope file_browser path=%:p:h select_buffer=true<CR>
nnoremap <leader>b :Telescope buffers<CR>

"Git commands
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gl :GcLog<CR>
nnoremap <leader>gP :Git push<CR>
nnoremap <leader>gp :Git pull<CR>
nnoremap <leader>ga :Gwrite<CR>

" open lazygit
nnoremap <leader>gg :LazyGit<CR>

" use Undotree
nnoremap <leader>u :UndotreeToggle<CR>

" Copilot remaps
nnoremap <leader>gc :CopilotChat<CR>


" PLUGINS
" -----------------------------------

call plug#begin()

" Dependencies for other plugins
Plug 'nvim-lua/plenary.nvim'    " necessary for lua functions in general

" Essential Plugins
Plug 'mbbill/undotree'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-commentary'
Plug 'RRethy/vim-illuminate'
Plug 'tpope/vim-fugitive'       " simple git plugin
Plug 'kdheepak/lazygit.nvim'    " gui for git commands
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " provides basic library functions
Plug 'junegunn/fzf.vim'         " provides a useful commands
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'williamboman/mason.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim' " nice utility to keep track of packages
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }
Plug 'tpope/vim-surround'
Plug 'HiPhish/rainbow-delimiters.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
Plug 'milanglacier/yarepl.nvim'

" Snippets
Plug 'rafamadriz/friendly-snippets'
Plug 'mattn/emmet-vim'          " expand abbreviations

" LSP
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'j-hui/fidget.nvim'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'

" Useful for webdev
Plug 'windwp/nvim-ts-autotag'   " auto close and auto rename HTML tags
Plug 'yuezk/vim-js'             " for vim-jsx-pretty
Plug 'HerringtonDarkholme/yats.vim'" for vim-jsx-pretty
Plug 'maxmellon/vim-jsx-pretty'


" Color Plugins
Plug 'ayu-theme/ayu-vim'

" Copilot
" NOTE: To use copilot, we will need to execute :Copilot setup and follow the
" instructions. This will generate a token that we will need to paste in
" github.com/login/device and then we will be able to use copilot
" Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim' 
Plug 'zbirenbaum/copilot.lua'

" TODO: explore if copilot.lua is better and if CopilotChat works with copilot.lua
" https://github.com/zbirenbaum/copilot.lua

" TODO: Add avante to the list of plugins if it doesn't clash with copilot
" https://github.com/yetone/avante.nvim



" LATEX
Plug 'lervag/vimtex'

call plug#end()
"
" ------------------------------------


" AYU COLORS
" ------------------------------------
colorscheme ayu         " The ayu plugin must be installed
let ayucolor="dark"   " for dark version of theme
" I didn't like the color of the line numbers, 
" and some other keywords because they were too dark
exe "hi! LineNr guifg=#4d5c6d guibg=NONE gui=NONE" 
exe "hi! NonText guifg=#4d5c6d guibg=NONE gui=NONE" 
exe "hi! SpecialKey guifg=#4d5c6d guibg=NONE gui=NONE" 
exe "hi! Directory guifg=#707c8a guibg=NONE gui=NONE" 

" LATEX CONFIGURATIONS
" ------------------------------------
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" EMMET CONFIGURATIONS
" ------------------------------------
" To accept a snippet use <C-y> followed by a comma (,)
" If you cant to remap <C-y> to something else, use: 
let g:user_emmet_leader_key='<C-y>'


" LUA CONFIGURATIONS
" ------------------------------------
lua << EOF

require('yarepl').setup({})

require('tel')
require('ts')
require('lsp')
require('yaml_fix')

require('CopilotChat').setup({})

require('copilot').setup({
    panel = {
        auto_trigger = true,
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept = false,
        },
    }
})

vim.keymap.set("i", '<Tab>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, {
  silent = true,
})

require('lualine').setup({
    options = {
        theme = 'ayu_mirage',
        },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{'filename', path=1}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
        }
})
require("nvim-autopairs").setup {
    map_cr = true;
    enable_check_bracket_line = false
}

-- Basic Neovim Configurations 
-- ------------------------------------
vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'  -- line numbers for netrw
vim.o.splitright = true  -- prefer right splits over left splits
vim.opt.conceallevel = 0 -- don't hide my json strings
-- stop the auto commnet on new lines
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')


-- NVIM-TS-AUTOTAG CONFIGURATION
-- -----------------------------------
require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = true
    }
  }
})


-- TODO CONFIGURATION
-- -----------------------------------
require("todo-comments").setup {
  -- Your custom configuration goes here (optional)
}
-- Keymaps for todo-comments. These are for jumping between comments
vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })



-- Autosave on text change
-- -----------------------------------

-- This one liner will save the file every time you type something in insert mode (from stackoverflow)

-- vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {command = "silent! update"})

-- This is a more complex version that will save the file after 10 seconds (or any number of seconds) of inactivity.
-- I currently have it disabled because it was causing some issues with the undo tree

-- local timer = nil
-- local delay = 10000 -- delay in milliseconds
-- 
-- vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
--   callback = function()
--     if timer then
--       vim.fn.timer_stop(timer)
--     end
--     timer = vim.fn.timer_start(delay, function()
--       vim.cmd('silent! update')
--     end)
--   end
-- })



-- HARPOON
-- -----------------------------------
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    local make_finder = function()
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(paths, item.value)
        end

        return require('telescope.finders').new_table { results = paths }
      end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        layout_config = {
            height = 0.4,
            width = 0.7,
        },
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<C-d>", function()
                local state = require("telescope.actions.state")
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)

                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(make_finder())
            end)
            return true
        end,
    }):find()
end

-- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

harpoon:extend({
  UI_CREATE = function(cx)
    vim.keymap.set("n", "<C-v>", function()
      harpoon.ui:select_menu_item({ vsplit = true })
    end, { buffer = cx.bufnr })

    vim.keymap.set("n", "<C-h>", function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })
  end,
})


EOF
