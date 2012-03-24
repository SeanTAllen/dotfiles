# Start Keymando at login
# -----------------------------------------------------------
start_at_login

# Disable Keymando when using these applications
# -----------------------------------------------------------
# disable "Remote Desktop Connection"
# disable /VirtualBox/

# Basic mapping
# -----------------------------------------------------------
# map "<Ctrl-[>", "<Escape>"
# map "<Ctrl-m>", "<Ctrl-F2>"

# -----------------------------------------------------------
# Visit http://keymando.com to see what Keymando can do!
# -----------------------------------------------------------

except "Emacs", "Terminal", "iTerm" do
  # save
  map "<Ctrl-x><Ctrl-s>", "<Cmd-s>"
  
  # copy/cut/paste
  map "<Alt-w>",  "<Cmd-c>"
  map "<Ctrl-w>", "<Cmd-x>"
  map "<Ctrl-y>", "<Cmd-v>"
  
  # undo
  map "<Ctrl-x>u", "<Cmd-z>"

  # quit
  map "<Ctrl-x><Ctrl-c>", "<Cmd-q>"

  # search
  map "<Ctrl-s>", "<Cmd-f>"
end

only "Google Chrome" do
  #pinboard remappings
  map "<Cmd-L>", "<Alt-L>"
  map "<Cmd-U>", "<Alt-U>"
  map "<Cmd-A>", "<Alt-A>"
end

only "Safari" do
  previous_tab = "<Ctrl-Shift-Tab>"
  next_tab     = "<Ctrl-Tab>"
  
  # next and previous tab remappings
  nmap "<Left>",         previous_tab
  map "<Ctrl-x><Left>",  previous_tab
  map "<Ctrl-Left>",     previous_tab
  nmap "<Right>",        next_tab
  map "<Ctrl-x><Right>", next_tab
  map "<Ctrl-Right>",    next_tab

  # pinboard remappings
  map "<Cmd-P>", "<Alt-p>"
  map "<Cmd-A>", "<Alt-a>"
  map "<Cmd-L>", "<Alt-l>"
  map "<Cmd-F>", "<Alt-f>"
  map "<Cmd-U>", "<Alt-u>"
  map "<Cmd-O>", "<Alt-o>"
end
