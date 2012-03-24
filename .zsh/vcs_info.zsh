zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:git*' formats "%{$reset_color%}%s:(%{$fg[yellow]%}%b%{$reset_color%})" 

autoload -Uz vcs_info

precmd() {
    vcs_info
} 
