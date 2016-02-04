" COLORS
syntax on				" syntax highlighting on
colorscheme up			" set my color scheme

" SPACES AND TABS

set tabstop=4 		" number of visual spaces per tab
set shiftwidth=4	" auto indent number of visual spaces per tab
set softtabstop=4 	" number of spaces in tab when editing
set autoindent		" auto indents
set noexpandtab		" insert tabs instead of spaces when indenting

" UI CONFIG

set number		" show line numbers
set showcmd		" show command in bottom bar
set cursorline		" highlight the current line

filetype indent on	" load filetype specific indent files
set wildmenu		" visual autocomplete for command menu
set lazyredraw		" only redraw screen when we need to
set showmatch		" highlight matching [{()}]

" SEARCHING

set incsearch		" search as characters are entered
set hlsearch		" highlight matches

" turn off search highlight using ,<space>
nnoremap <leader><space> :nohlsearch<CR>

" FOLDING

set foldenable		" enable folding
set foldlevelstart=10	" open most folds by default
set foldnestmax=10		" 10 nested fold max
set foldmethod=indent	" fold based on indent level

" space open closes folds
nnoremap <space> za

" MOVEMENT

nnoremap j gj			" move vertically by visual line
nnoremap k gk			
" Vim keybindings for movement when in insert mode
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>

" Vim keybindings for navigating splits
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k

" SHORTCUTS

inoremap jk <esc>		" make jk exit visual mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>	" Scroll command history with C-p/n instead of up/down

" BACKUPS

set nobackup
set nowritebackup
set undodir=~/.vim/undo//
set noswapfile

" Pathogen
execute pathogen#infect()

" GUI
set guioptions-=m		" Remove menu bar
set guioptions-=T		" Remove toolbar
set guioptions-=r		" Remove right scrollbar
set guioptions-=L		" Remove left scrollbar
