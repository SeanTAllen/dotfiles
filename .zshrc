## machine specific - and not public
source ~/.profile

ZSH=$HOME/.zsh

fpath=("$ZSH/functions/" $fpath)
autoload -U compinit
compinit

# load config files
for config_file ($ZSH/*.zsh) source $config_file

## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER=less
export LC_CTYPE=$LANG

alias ebills="vi ~/Dropbox/Notes/bills.txt"

export EDITOR="vim"

export LEIN_BIN=$HOME/.lein/bin
export RUBYGEMS_BIN=$HOME/.gem/ruby/1.8/bin
export HASKELL_BIN=$HOME/Library/Haskell/bin
export SCALA_BIN=/opt/scala/bin
export RVM_BIN=$HOME/.rvm/bin
export PATH=$HOME/bin:$LEIN_BIN:$RUBYGEMS_BIN:$HASKELL_BIN:$PATH:$SCALA_BIN:$RVM_BIN
