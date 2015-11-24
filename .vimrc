" COLORS
syntax on				" syntax highlighting on
colorscheme molokai		" set my color scheme
let g:molokai_original = 1
let g:rehash256 = 1

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
" Emacs keybindings for movement when in insert mode
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <Up>

" SHORTCUTS

inoremap jk <esc>		" make jk exit visual mode
