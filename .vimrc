if exists('g:loaded_shared_vimrc')
	finish
endif
let g:loaded_shared_vimrc = 1

syntax on               " enable syntax highlighting
set cursorline          " highlight the current line
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
set expandtab           " spaces instead of tabs
set tabstop=4           " 4 spaces for tabs
set softtabstop=4       " 4 spaces for soft tabs
set shiftwidth=4        " 4 spaces for indentation
set noerrorbells        " turn off audio bell
set visualbell          " but leave on a visual bell
set hlsearch            " highlighted search results
set incsearch           " incremental search
set splitright
set lazyredraw
set foldmethod=indent
set foldnestmax=2
set foldlevelstart=99

if exists('+formatoptions')
	set formatoptions+=j  " Delete comment character when joining commented lines
endif

if exists('+sidescrolloff')
	set sidescrolloff=5
endif

if exists('+updatetime')
	set updatetime=50
endif

if exists('+signcolumn')
	set signcolumn=yes
endif

if exists('+breakindent')
	set breakindent
endif

if exists('+clipboard') && has('clipboard')
	set clipboard=unnamed   " allow yy, etc. to interact with OS X clipboard
endif

if exists('+termguicolors')
	set termguicolors       " enable true colors support when available
endif

if has('gui_macvim')
	set guioptions=aAace    " don't show scrollbar in MacVim
endif

let g:netrw_liststyle = 1
let g:netrw_sort_by = 'exten'  " Case-insensitive sorting by name

autocmd BufReadPost,FileReadPost * normal zR

filetype on             " enable filetype detection
filetype indent on      " enable filetype-specific indenting
filetype plugin on      " enable filetype-specific plugins

let mapleader = ' '

" column-width visual indication
" let &colorcolumn=join(range(81,999),",")
" highlight ColorColumn ctermbg=235 guibg=#001D2F

" reload the active config entrypoint
nnoremap <leader><CR> :source $MYVIMRC<CR>:nohl<CR>

" Redraw screen and remove search highlighting
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <leader>l :nohl<CR>

" make the current file executable
nnoremap <leader>x :!chmod +x %<CR>

" Close the current buffer
nnoremap <leader>X :bd<CR>

nnoremap <leader>h :split<CR>
nnoremap <leader>v :vsplit<CR>

" TMUX Scripts from vim
nnoremap <silent> <C-s> :silent !tmux neww tmux-sessionizer<CR>
nnoremap <silent> <C-g> :silent !tmux neww tmux-gh-sessionizer<CR>

" remaps for quicklists
nnoremap <leader>P :cprevious<CR>
nnoremap <leader>N :cnext<CR>
nnoremap <leader>] :cnext<CR>
nnoremap <leader>[ :cprev<CR>

" We can move code around when it is highlighted with J and K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" remaps to quickly paste from the system clipboard
vnoremap <leader>pp "+p
nnoremap <leader>pp "+p
vnoremap <leader>yy "+y
nnoremap <leader>yy "+y

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

if exists(':NERDTreeToggle')
	nnoremap <F2> :NERDTreeToggle<CR>
endif

if !has('nvim')
	inoremap {      {}<Left>
	inoremap {<CR>  {<CR>}<Esc>O
	inoremap {{     {
	inoremap {}     {}
endif

