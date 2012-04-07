"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

set encoding=utf-8
syntax enable
set t_Co=256
if has('gui_running') || has('mac')
  set background=dark
  colorscheme solarized-darker
endif

if has('gui_running')
  "turn off toolbari & scrollbar"
  set guioptions-=T
  set guioptions-=L
  set guioptions-=r

  if has('gui_macvim')
    set guifont=Inconsolata:h14
    
    "start fullscreen"
    set fu
  endif

  if has('gui_gtk')
    set guifont=Inconsolata\ Medium\ 12
  endif

endif

"set default tab size to 2"
set ts=2
set sw=2
set expandtab

""
let mapleader=','
