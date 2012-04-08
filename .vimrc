" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load bundled plugins 
call pathogen#infect()
call pathogen#helptags()

set encoding=utf-8
syntax enable

if has('gui_running')
  " turn off toolbari & scrollbar
  set guioptions-=T
  set guioptions-=L
  set guioptions-=r

  if has('gui_macvim')
    set guifont=Inconsolata:h14
    
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

" enable file type detection.
" use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

"
let mapleader=','

" search options
set incsearch
set hlsearch
set ignorecase
set smartcase

" line numbers on
set number
set numberwidth=3

" highlight current line
set cursorline

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

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif
augroup END


