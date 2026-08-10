set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" ----- Making Vim look good ---------------------------------
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" ----- Vim as a programmer's text editor -----------------------------
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-syntastic/syntastic'

" ----- Auto-Complete -----------------------------------
" Plugin 'ycm-core/YouCompleteMe'

"------- Git ------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" ----- Other text editing features -----------------------------------
Plugin 'Raimondi/delimitMate'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set smartindent
autocmd BufRead,BufWritePre *.sh normal gg=G	" auto indent saved shell script,

" ----- altercation/vim-colors-solarized settings -----
" syntax on
" set background=dark
" let g:solarized_termcolors=256
colorscheme molokai

" ----- bling/vim-airline settings -----
set laststatus=2			" Always show statusbar
let g:airline_powerline_fonts = 1	" Fancy arrow symbols, requires a patched font
let g:airline_detect_paste=1		" Show PASTE if in paste mode
let g:airline#extensions#tabline#enabled = 1 " Show airline for tabs too
let g:airline_theme='powerlineish'

" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" To have NERDTree always open on startup
"let g:nerdtree_tabs_open_on_console_startup = 1

" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
	au!
	au FileType tex let b:syntastic_mode = "passive"
augroup END

" ----- airblade/vim-gitgutter settings -----
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

"-------------------- AutoFormat ----------------
"let g:autoformat_autoindent = 0
"let g:autoformat_retab = 0
"let g:autoformat_remove_trailing_spaces = 0
noremap <F3> :Autoformat<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=1000	" keep 1000 lines of command line history
set number		" line numbers
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set linebreak		" wrap lines on 'word' boundaries
set scrolloff=3		" don't let the cursor touch the edge of the viewport
set splitright		" Vertical splits use right half of screen
set timeoutlen=100	" Lower ^[ timeout
set fillchars=fold:\ ,	" get rid of obnoxious '-' characters in folds

hi clear SignColumn	" We need this for plugins like Syntastic and vim-gitgutter which put symbols in the sign column.

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal-as-GUI settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('mouse')		" In many terminal emulators the mouse works just fine, thus enable it.
	set mouse=a
endif

if &t_Co > 2 || has("gui_running")
	syntax on		" Switch syntax highlighting on, when the terminal has colors
	set hlsearch		" Also switch on highlighting the last used search pattern.
endif
