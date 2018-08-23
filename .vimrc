" VUNDLE

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Place all plugins between calls
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'morhetz/gruvbox'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mattn/emmet-vim'
Plugin 'nvie/vim-flake8'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'leafgarland/typescript-vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'pangloss/vim-javascript'

call vundle#end()

"filetype plugin indent on

" END VUNDLE

" COLORS
syntax on				" syntax highlighting on
let g:gruvbox_italic=1  " Set colorscheme
set background=dark
colorscheme gruvbox

" SPACES AND TABS

set tabstop=4 		" number of visual spaces per tab
set shiftwidth=4	" auto indent number of visual spaces per tab
set softtabstop=4 	" number of spaces in tab when editing
set autoindent		" auto indents
set expandtab		" insert tabs instead of spaces when indenting
autocmd FileType ruby setlocal ts=2 sts=2 sw=2
autocmd FileType javascript setlocal ts=4 sts=4 sw=4
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab

" UI CONFIG

set number			            " show line numbers
set relativenumber	            " set relative line numbers
set showcmd			            " show command in bottom bar
set cursorline		            " highlight the current line
set backspace=indent,eol,start  " make backspace behave normally in insert mode

"filetype indent on	" load filetype specific indent files
set wildmenu		" visual autocomplete for command menu
set lazyredraw		" only redraw screen when we need to
set showmatch		" highlight matching [{()}]

" SEARCHING

set incsearch		" search as characters are entered
set hlsearch		" highlight matches

" turn off search highlight using \h
nnoremap <leader>h :nohlsearch<CR>

" FOLDING

set foldenable			" enable folding
set foldlevelstart=10	" open most folds by default
set foldnestmax=10		" 10 nested fold max
set foldmethod=indent	" fold based on indent level

" space open closes folds
nnoremap <space> za

" SPLITS
set splitbelow		" Split to bottom and right which feels more natural
set splitright

" MOVEMENT

nnoremap j gj			" move vertically by visual line
nnoremap k gk			

" Vim keybindings for movement when in insert mode
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>

" Vim keybindings for navigating splits
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Navigate Tabs
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>

" SHORTCUTS

inoremap jk <esc>		" make jk exit visual mode
vnoremap <C-c> "+y		" Copy to system clipboar 
nnoremap <Insert> "+p	" Paste from system clipboard
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>	" Scroll command history with C-p/n instead of up/down
vnoremap . :norm .<CR>	" Allow repeating . command in visual mode

" BACKUPS

set nobackup
set nowritebackup
set undodir=~/.vim/undo//
set noswapfile

" GUI
set guioptions-=m		" Remove menu bar
set guioptions-=T		" Remove toolbar
set guioptions-=r		" Remove right scrollbar
set guioptions-=L		" Remove left scrollbar


"""""""""""
" PLUGINS "
"""""""""""

" CTRL-P

let g:ctrlp_working_path_mode = 'c'

" Syntastic (Syntax checking)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
let g:syntastic_javascript_checkers=['eslint']
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']

" Fugitive (Git wrapper)
set statusline+=%{fugitive#statusline()}

" Vim-Airline

set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

function! AirlineOverride(...)
	call a:l.add_section('StatusLine', 'all')
	call a:l.split()
	call a:l.add_section('Error', '%p%%')
endfunction

" Vim Javascript

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

