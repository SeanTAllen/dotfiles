" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Don't use modelines from files
set modelines=0

" Force myself to learn real vim movement commands
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Load bundled plugins 
call pathogen#infect()
call pathogen#helptags()

set encoding=utf-8
syntax enable

if has('gui_running')
  " turn off toolbar & scrollbar & menubar
  set guioptions-=T
  set guioptions-=L
  set guioptions-=r
  set guioptions-=m

  if has('gui_macvim')
    set guifont=Anonymous\ Pro:h14
    
    " start fullscreen
    set fu
  endif

  if has('gui_gtk')
    set guifont=Inconsolata\ Medium\ 12
  endif

endif

" set tab handling and indentation.
set ts=2
set sw=2
set expandtab
set autoindent

" toggle paste mode (to paste properly indented text)
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" enable file type detection.
" use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" switch leader
let mapleader=','

" search options
set incsearch
set hlsearch
set ignorecase
set smartcase
" use perl/python style regexes for search
nnoremap / /\v
vnoremap / /\v
" pressing <leader><space> clears the search highlights
nmap <silent> <leader><space> :nohlsearch<CR>
" Center the display line after searches.
nnoremap n   nzz
nnoremap N   Nzz
nnoremap *   *zz
nnoremap #   #zz
nnoremap g*  g*zz
nnoremap g#  g#zz
" Make global replace the default for substitutions
" To do a single substitution, add the 'g' option
set gdefault

set numberwidth=3
nn <silent> <leader>vn :NumbersToggle<CR>

" highlight current line
set cursorline
" keep current line vertically centered
set scrolloff=999

" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu

" colors
set t_Co=256
if has('gui_running') || has('mac')
  set background=dark
  colorscheme solarized-darker
endif

" disable backup files i don't use
set nobackup
set noswapfile

" Map Control+Up/Down to move lines and selections up and down.
" Normal mode
nnoremap <silent>  <C-Up>    :move -2<CR>
nnoremap <silent>  <C-Down>  :move +<CR>
" Visual mode (only; does not include Select mode)
xnoremap <silent>  <C-Up>    :move '<-2<CR>gv
xnoremap <silent>  <C-Down>  :move '>+<CR>gv
" Insert mode
imap     <silent>  <C-Up>    <C-O><C-Up>
imap     <silent>  <C-Down>  <C-O><C-Down>
" Select mode
smap     <silent>  <C-Up>    <C-G><C-Up><C-G>
smap     <silent>  <C-Down>  <C-G><C-Down><C-G>

" Ack
nnoremap <leader>a :Ack!<space>
" Ack for the last search.
nnoremap <silent> <leader>/ :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Turns off auto commenting
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

