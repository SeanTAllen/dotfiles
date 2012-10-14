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

export EDITOR="vim"

## less
export LESS="-eirMX"

## findbugs
export FINDBUGS_HOME=/usr/local/Cellar/findbugs/2.0.1/libexec

## machine specific settings
source ~/.profile

