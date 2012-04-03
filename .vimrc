"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

set encoding=utf-8
syntax enable
set t_Co=256
if has('gui_running') || has('mac')
  set background=dark
  colorscheme solarized
endif

"turn off toolbar"
set guioptions-=T

"set default tab size to 2"
set ts=2

"set font when running in gui like macvim/gvim"
set guifont=Inconsolata:h14

""
let mapleader=','

