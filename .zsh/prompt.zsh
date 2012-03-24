autoload -U colors && colors
autoload -U promptinit
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:(hg*|git*):*' get-revision true
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true
zstyle ':vcs_info:(hg*|git*):*' stagedstr "✗"
zstyle ':vcs_info:(hg*|git*):*' unstagedstr "?"
zstyle ':vcs_info:hg*:*' branchformat '%b'
zstyle ':vcs_info:(hg*|git*)' formats "%{$reset_color%}%s:(%{$fg[yellow]%}%b%{$reset_color%}) %{$fg[yellow]%}%c %u%{$reset_color%} " 

precmd() {
    vcs_info
} 

setopt prompt_subst

PROMPT='%{$fg[yellow]%}➜ %{$fg[green]%}%p %{$fg[cyan]%}%c %{$fg[blue]%}${vcs_info_msg_0_}%{$fg[blue]%} % %{$reset_color%}'

