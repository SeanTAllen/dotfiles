# prompt
function cwd_name
  pwd | xargs basename
end

set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showstashstate 1
set __fish_git_prompt_showuntrackedfiles 1
#set __fish_git_prompt_showupstream 'auto'
set __fish_git_prompt_color 'yellow'
set __fish_git_prompt_color_prefix normal
set __fish_git_prompt_color_suffix normal
set __fish_git_prompt_char_stagedstate '✗'
set __fish_git_prompt_char_untrackedfiles '?'
set __fish_git_prompt_char_dirtystate '+'

function fish_prompt
  printf '%s%s%s%s%s%s%s ' (set_color 'yellow') '➜  ' (set_color 'cyan') (cwd_name) (set_color normal) (__fish_git_prompt ' git:(%s)')
end


