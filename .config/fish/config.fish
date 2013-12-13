function revert; git checkout .; end

###
### aliases
###

alias fucking sudo
alias fu sudo

alias vi vim

# directory movement aliases
alias ..    'cd ..'
alias ...   'cd ../..'
alias ....  'cd ../../..'
alias ..... 'cd ../../../..'

alias work 'ssh sean@sallen'
alias gw   'ssh -N sshgw'

alias add      'git add'
alias amend    'git amend'
alias branches 'git branches'
alias ci       'git ci'
alias co       'git co'
alias di       'git diff'
alias fetch    'git fetch'
alias log      'git log'
alias pom      'git pom'
alias pull     'git pull'
alias push     'git push'
alias snap     'git snap'
alias st       'git status'
alias tag      'git tag'
alias tags     'git tags'

###
### environment variables
###

set -gx PAGER less
set -gx LC_CTYPE $LANG
set -gx EDITOR 'vim'
set -gx FINDBUGS_HOME /usr/local/Cellar/findbugs/2.0.1/libexec
set -gx GITHUB_USER SeanTAllen
set -gx HGUSER 'Sean T. Allen <sean@monkeysnatchbanana.com>'
set -gx CDPATH $CDPATH . $HOME/code/ $HOME/code/tlc
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.7.0_10.jdk/Contents/Home
set -gx MAVEN_OPTS '-Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=128m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5099 -Dcom.sun.management.jmxremote'
set -gx IDEA_JDK /System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home

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

