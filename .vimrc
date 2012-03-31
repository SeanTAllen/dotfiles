set encoding=utf-8
syntax enable
set t_Co=256
if has('gui_running') || has('mac')
  set background=dark
  colorscheme solarized
endif

"turn off toolbar"
set guioptions-=T
