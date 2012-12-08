function source
  set -l file $HOME/.config/fish/$argv.fish

  if test -s $file
    . $file
  end
end

source alias
source environment
source path
source prompt
source local

# turn off greeting
set -gx fish_greeting

