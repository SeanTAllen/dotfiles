###
### aliases
###

alias fucking sudo
alias fu sudo

alias vi vim
alias ebills 'vim ~/Dropbox/Notes/bills.txt'

# directory movement aliases
alias ..    'cd ..'
alias ...   'cd ../..'
alias ....  'cd ../../..'
alias ..... 'cd ../../../..'

alias work 'ssh sean@sallen'
alias gw   'ssh -N sshgw'

###
### environment variables
###

set -gx PAGER less
set -gx LC_CTYPE $LANG
set -gx EDITOR 'vim'
set -gx FINDBUGS_HOME /usr/local/Cellar/findbugs/2.0.1/libexec
set -gx GITHUB_USER SeanTAllen
set -gx HGUSER 'Sean T. Allen <sean@monkeysnatchbanana.com>'
set -gx CDPATH $CDPATH . $HOME/code/
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.7.0_10.jdk/Contents/Home

###
### path 
###

set -gx PATH $HOME/.rbenv/shims $HOME/bin /usr/local/share/python /usr/local/bin /bin /usr/bin /usr/local/sbin /sbin /usr/sbin /usr/X11R6/bin

###
### prompt
###

function cwd_name
  pwd | xargs basename
end

set -gx __fish_git_prompt_showdirtystate 1
set -gx __fish_git_prompt_showstashstate 1
set -gx __fish_git_prompt_showuntrackedfiles 1
set -gx __fish_git_prompt_showupstream 'auto'
set -gx __fish_git_prompt_color 'yellow'
set -gx __fish_git_prompt_color_prefix normal
set -gx __fish_git_prompt_color_suffix normal
set -gx __fish_git_prompt_char_stagedstate '✗'
set -gx __fish_git_prompt_char_untrackedfiles '?'
set -gx __fish_git_prompt_char_dirtystate '+'
set -gx __fish_git_prompt_char_upstream_equal 

function fish_prompt
  printf '%s%s%s%s%s%s%s ' (set_color 'yellow') '➜  ' (set_color 'cyan') (cwd_name) (set_color normal) (__fish_git_prompt ' git:(%s)')
end

###
### local only
###

set -l localconfig $HOME/.config/fish/$argv.fish
if test -s $localconfig
  . $localconfig
end

###
### misc
###

# turn off greeting
set -gx fish_greeting

