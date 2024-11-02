syntax on               " enable syntax highlighting
set cursorline          " highlight the current line
set ruler             " show line number in bar
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
set mouse=a
set ruler
set laststatus=2
set ignorecase
set smartcase
set undofile
set undodir=~/.vim/undodir
set hls ic
set updatetime=50
:set splitright

filetype on             " enable filetype detection
filetype indent on      " enable filetype-specific indenting
filetype plugin on      " enable filetype-specific plugins
" colorscheme cobalt      " requires cobalt.vim to be in ~/.vim/colors

" column-width visual indication
" let &colorcolumn=join(range(81,999),",")
" highlight ColorColumn ctermbg=235 guibg=#001D2F



" tabs and indenting
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


" other
set guioptions=aAace    " don't show scrollbar in MacVim
" call pathogen#infect()  " use pathogen

" clipboard
" set clipboard=unnamed   " allow yy, etc. to interact with OS X clipboard
"

" " remapped keys
" inoremap {      {}<Left>
" inoremap {<CR>  {<CR>}<Esc>O
" inoremap {{     {
" inoremap {}     {}



nnoremap <leader>x :!chmod +x %<CR>
nnoremap <silent> <C-s> :silent !tmux neww tmux-sessionizer<CR>
nnoremap <silent> <leader>ch :silent !tmux split-window -h cheeto<CR>

let mapleader = " "
nnoremap <leader>pv :Vex!<CR>
nnoremap <leader>e :Ex<CR>
" So that we can close netrw with <leader>pv the same way we got into it. 
autocmd filetype netrw noremap <buffer> <leader>pv :q<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

" Redraw screen and remove search highlighting
nnoremap <leader>l :nohl<CR><C-L>

" Fuzzy find files
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>pf :Files<CR>
nnoremap <leader>tf :Telescope find_files<CR>
nnoremap <leader>fb :Telescope file_browser path=%:p:h select_buffer=true<CR>
nnoremap <leader>b :Telescope buffers<CR>
nnoremap <leader>r :Rg<CR>

nnoremap <leader>h :split<CR>

"Git commands
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gl :GcLog<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gP :Git push<CR>
nnoremap <leader>gp :Git pull<CR>
nnoremap <leader>ga :Gwrite<CR>

" open lazygit
nnoremap <leader>gg :LazyGit<CR>

" nice remaps for quicklists
nnoremap <leader>P :cprevious<CR>
nnoremap <leader>N :cnext<CR>

vnoremap <leader>p "+p
nnoremap <leader>p "+p
vnoremap <leader>y "+y
nnoremap <leader>y "+y
nnoremap <leader>u :UndotreeToggle<CR>

" We can move code around when it is highlighted with J and K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>


nnoremap <leader>q :wq<CR>
nnoremap <leader>Q :qa<CR>
nnoremap <leader>w <C-w>
nnoremap <leader>W :w<CR>

" nnoremap <C-d> <C-d>zz
" nnoremap <C-u> <C-u>zz


nnoremap n nzzzv
nnoremap N Nzzzv


nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>


" PLUGINS
" -----------------------------------
"
call plug#begin()

Plug 'nvim-lua/plenary.nvim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ayu-theme/ayu-vim'
Plug 'kdheepak/lazygit.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mbbill/undotree'
Plug 'williamboman/mason.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
Plug 'RRethy/vim-illuminate'

" LSP plugins and snippets
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'L3MON4D3/LuaSnip'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v4.x'}
Plug 'HiPhish/rainbow-delimiters.nvim'

" Things for web development
Plug 'AndrewRadev/tagalong.vim'
Plug 'windwp/nvim-ts-autotag'
Plug 'tpope/vim-surround'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mattn/emmet-vim'


Plug 'windwp/nvim-autopairs'

" Copilot
Plug 'github/copilot.vim'
"  To use copilot, we will need to execute :Copilot setup and follow the
"  instructions. This will generate a token that we will need to paste in
"  github.com/login/device and then we will be able to use copilot

" Harpoon
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }

" LATEX
Plug 'lervag/vimtex'

Plug 'nvim-telescope/telescope-file-browser.nvim'


call plug#end()
"
" ------------------------------------

" EMMET CONFIGURATIONS
" ------------------------------------
" let g:user_emmet_leader_key='<C-M>'  " Set the leader key to <C-M> so that we can do <C-M>, to expand emmet

" If at some poitn we want to add our own snippets, we can do it like this

" let g:user_emmet_settings = {
"   'variables': {'lang': 'ja'},
"   'html': {
"     'default_attributes': {
"       'option': {'value': v:null},
"       'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
"     },
"     'snippets': {
"       'html:5': "<!DOCTYPE html>\n"
"               ."<html lang=\"${lang}\">\n"
"               ."<head>\n"
"               ."\t<meta charset=\"${charset}\">\n"
"               ."\t<title></title>\n"
"               ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
"               ."</head>\n"
"               ."<body>\n\t${child}|\n</body>\n"
"               ."</html>",
"     },
"   },
" }

" ------------------------------------

" TAGALONG CONFIGURATIONS
" ------------------------------------
let g:tagalong_verbose = 1
let g:tagalong_filetypes = ['eco', 'eelixir', 'ejs', 'eruby', 'html', 'htmldjango', 'javascriptreact', 'jsx', 'typescript', 'php', 'typescriptreact', 'typescript.tsx', 'xml']
" There is a bug with tagalong and jsx, so we need to add this to fix it. In my case when selecting text it overrides the registers
let g:tagalong_mappings = ['c', 'C', 'i', 'a']
" ------------------------------------

" LATEX CONFIGURATIONS
" ------------------------------------
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'


" AYU COLORS
" ------------------------------------
set termguicolors     " enable true colors support
let ayucolor="dark"   " for dark version of theme
colorscheme ayu
" I didn't like the color of the line numbers, and the rest because they are way too dark
exe "hi! LineNr guifg=#4d5c6d guibg=NONE gui=NONE" 
exe "hi! NonText guifg=#4d5c6d guibg=NONE gui=NONE" 
exe "hi! SpecialKey guifg=#4d5c6d guibg=NONE gui=NONE" 
exe "hi! Directory guifg=#707c8a guibg=NONE gui=NONE" 
" ------------------------------------

" LUA CONFIGURATIONS
"
lua << EOF

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

-- -----------------------------------

-- Adds line numbers to the netrw buffer
vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

vim.o.splitright = true

-- TREESITTER
-- ------------------------------------
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { 
        "c", 
        "cpp", 
        "cmake", 
        "css", 
        "csv", 
        "diff", 
        "gitignore", 
        "go", 
        "html", 
        "http", 
        "java", 
        "javascript", 
        "json", 
        "sql", 
        "tmux", 
        "typescript", 
        "tsx", 
        "xml", 
        "yaml", 
        "lua", 
        "vim", 
        "vimdoc", 
        "markdown", 
        "markdown_inline", 
        "make", 
        "dockerfile", 
        "awk", 
        "bash", 
        "nginx", 
        "matlab", 
        "rust", 
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
-- -----------------------------------

-- MASON 
-- -----------------------------------
require('mason').setup({})
-- -----------------------------------

-- MASON PACKAGES
-- -----------------------------------
require('mason-tool-installer').setup {

    -- a list of all tools you want to ensure are installed upon start
    ensure_installed = {

        -- LINTERS
        'ansible-lint',
        'curlylint',
        'djlint',
        'jsonlint',
        'misspell',
        'eslint_d',
        'pydocstyle',

    },
}

-- -----------------------------------

-- LSP 
-- -----------------------------------

local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  lsp_zero.buffer_autoformat()
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', {clear = true}),
    callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
    end,
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'ts_ls',
        'rust_analyzer',
        'dockerls',
        'docker_compose_language_service',
        'arduino_language_server',
        'ansiblels',
        'bashls',
        'cmake',
        'cssls',
        'gopls',
        'html',
        'java_language_server',
        'jsonls',
        'marksman',
        'texlab',
        'pyright'

    },
    handlers = {
        function(server_name)
        require('lspconfig')[server_name].setup({
        capabilities = lsp_capabilities,
        })
        end,
        lua_ls = function()
        require('lspconfig').lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT'
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    library = {
                        vim.env.VIMRUNTIME,
                    }
                    }
                }
            }
        })
        end,
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    sources = cmp.config.sources({
        {name = 'nvim_lsp'},  
        {name = 'luasnip'},  
    }, {
        {name = 'buffer'},
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm({select = true}),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})


-- Apparently needed for nvim-autopairs to work with cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)


-- -----------------------------------


-- ILLUMINATE
-- -----------------------------------
-- default configuration
require('illuminate').configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = {
        'lsp',
        'treesitter',
    },
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = true,
    -- large_file_cutoff: number of lines at which to use large_file_config
    -- The `under_cursor` option is disabled when this cutoff is hit
    large_file_cutoff = nil,
    -- min_count_to_highlight: minimum number of matches required to perform highlighting
    min_count_to_highlight = 1,
})

-- -----------------------------------


-- HARPOON
-- -----------------------------------

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
-- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

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

-- -----------------------------------  

-- CLIPBOARD LOADING
-- -----------------------------------  
-- local is_wsl = vim.fn.has "wsl"
-- local is_windows = vim.fn.has "win32" or vim.fn.has "win64"
-- local is_mac = vim.fn.has "macunix"
-- local is_unix = vim.fn.has "unix"
-- 
-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
--   once = true,
--   callback = function()
--     if is_windows == 1 and not is_wsl == 1 then
--       print "Using Windows clipboard."
--       vim.g.clipboard = {
--         copy = {
--           ["+"] = "win32yank.exe -i --crlf",
--           ["*"] = "win32yank.exe -i --crlf",
--         },
--         paste = {
--           ["+"] = "win32yank.exe -o --lf",
--           ["*"] = "win32yank.exe -o --lf",
--         },
--       }
--     elseif is_mac == 1 then
--       vim.g.clipboard = {
--         copy = {
--           ["+"] = "pbcopy",
--           ["*"] = "pbcopy",
--         },
--         paste = {
--           ["+"] = "pbpaste",
--           ["*"] = "pbpaste",
--         },
--       }
--     elseif is_unix == 1 or is_wsl == 1 then
--       if vim.fn.executable "xclip" == 1 then
--         vim.g.clipboard = {
--           copy = {
--             ["+"] = "xclip -selection clipboard",
--             ["*"] = "xclip -selection clipboard",
--           },
--           paste = {
--             ["+"] = "xclip -selection clipboard -o",
--             ["*"] = "xclip -selection clipboard -o",
--           },
--         }
--       elseif vim.fn.executable "xsel" == 1 then
--         vim.g.clipboard = {
--           copy = {
--             ["+"] = "xsel --clipboard --input",
--             ["*"] = "xsel --clipboard --input",
--           },
--           paste = {
--             ["+"] = "xsel --clipboard --output",
--             ["*"] = "xsel --clipboard --output",
--           },
--         }
--       end
--     end
-- 
--     vim.opt.clipboard = "unnamedplus"
--   end,
--   desc = "Lazy load clipboard",
-- })
-- -----------------------------------  

-- This function attempts to set the correct filetype for Docker Compose YAML files
function docker_fix()
    -- Get the current file's name without extension
    local filename = vim.fn.expand("%:t:r")

    -- List of common Docker Compose file name patterns
    local docker_file_names = { "^docker%-compose", "^compose" }

    -- Iterate through the list of Docker Compose file name patterns
    for _, pattern in ipairs(docker_file_names) do
        -- Check if the current file's name matches any of the patterns
        if filename:match(pattern) then
            -- If it does, set the filetype to "yaml.docker-compose"
            vim.bo.filetype = "yaml.docker-compose"
            return
        end
    end
    -- If no Docker Compose file name pattern is matched, the function exits without changing the filetype
end

-- This function attempts to set the correct filetype for Ansible YAML files
function ansible_fix()
    -- Get the current file's full path
    local filepath = vim.fn.expand("%:p")

    -- List of directories commonly used in Ansible projects
    local ansible_dirs = { "/playbook/", "/tasks/", "/roles/" }

    -- Iterate through the list of Ansible directories
    for _, dir in ipairs(ansible_dirs) do
        -- Check if the current file's path contains any of the Ansible directories
        if filepath:match(dir) then
            -- If it does, set the filetype to "yaml.ansible"
            vim.bo.filetype = "yaml.ansible"
            return
        end
    end
    -- If no Ansible directory is found, the function exits without changing the filetype
end


function yaml_filetype_detector()
    -- Get the file extension
    local file_ext = vim.fn.expand("%:e")
    
    -- Only proceed if the file is a YAML file
    if file_ext ~= "yaml" and file_ext ~= "yml" then
        return
    end

    docker_fix()
    ansible_fix()
    
end

-- Create an autocommand to run the yaml_filetype_detector function every time a file is read
vim.cmd([[au BufRead * lua yaml_filetype_detector()]])


-- TELESCOPE & TELESCOPE FILE BROWSING CONFIGURATION 
-- -----------------------------------
local fb_actions = require "telescope._extensions.file_browser.actions"

require("telescope").setup {
defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
        i = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            ["<C-h>"] = "which_key"
        }
    }
},
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = false,

      path = vim.loop.cwd(),
      cwd = vim.loop.cwd(),
      cwd_to_path = false,
      grouped = false,
      files = true,
      add_dirs = true,
      depth = 4,
      auto_depth = false,
      select_buffer = false,
      hidden = { file_browser = false, folder_browser = false },
      respect_gitignore = vim.fn.executable "fd" == 1,
      no_ignore = false,
      follow_symlinks = false,
      browse_files = require("telescope._extensions.file_browser.finders").browse_files,
      browse_folders = require("telescope._extensions.file_browser.finders").browse_folders,
      hide_parent_dir = false,
      collapse_dirs = false,
      prompt_path = false,
      quiet = false,
      dir_icon = "",
      dir_icon_hl = "Default",
      display_stat = { date = true, size = true, mode = true },
      use_fd = true,
      git_status = true,
      mappings = {
        ["i"] = {
          ["<A-c>"] = fb_actions.create,
          ["<S-CR>"] = fb_actions.create_from_prompt,
          ["<A-r>"] = fb_actions.rename,
          ["<A-m>"] = fb_actions.move,
          ["<A-y>"] = fb_actions.copy,
          ["<A-d>"] = fb_actions.remove,
          ["<C-o>"] = fb_actions.open,
          ["<C-g>"] = fb_actions.goto_parent_dir,
          ["<C-e>"] = fb_actions.goto_home_dir,
          ["<C-w>"] = fb_actions.goto_cwd,
          ["<C-t>"] = fb_actions.change_cwd,
          ["<C-f>"] = fb_actions.toggle_browser,
          ["<C-h>"] = fb_actions.toggle_hidden,
          ["<C-s>"] = fb_actions.toggle_all,
          ["<bs>"] = fb_actions.backspace,
        },
        ["n"] = {
          ["c"] = fb_actions.create,
          ["r"] = fb_actions.rename,
          ["m"] = fb_actions.move,
          ["y"] = fb_actions.copy,
          ["d"] = fb_actions.remove,
          ["o"] = fb_actions.open,
          ["g"] = fb_actions.goto_parent_dir,
          ["e"] = fb_actions.goto_home_dir,
          ["w"] = fb_actions.goto_cwd,
          ["t"] = fb_actions.change_cwd,
          ["f"] = fb_actions.toggle_browser,
          ["h"] = fb_actions.toggle_hidden,
          ["s"] = fb_actions.toggle_all,
        }
      },
    },
  },
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"


-- -----------------------------------


-- STOP THE STUPID AUTO COMMNET ON NEW LINES
-- -----------------------------------
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')
-- -----------------------------------


-- AUTOPAIRS
-- -----------------------------------
require("nvim-autopairs").setup {
    map_cr = true;
}
-- -----------------------------------

vim.opt.conceallevel = 0 -- don't hide my json strings


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
      enable_close = true,
    }
 }
})
-- -----------------------------------

EOF










