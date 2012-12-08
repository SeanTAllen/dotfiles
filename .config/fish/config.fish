function source
  set -l file $HOME/.config/fish/$argv.fish

  if test -s $file
    . $file
  end
end

source local
source alias
source environment
source path
source prompt

# turn off greeting
set -gx fish_greeting

