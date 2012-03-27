desc 'Links dotfiles into standard locations'
task :install do
  linkdir 'bin', 'bin2'
  [ '.emacs.d',
    '.hgext', 
    '.keymando',
    '.sublimetext2',
    '.vim',
    '.zsh',
  ].each do |dotfile|
    linkdir dotfile, dotfile 
  end

  [ '.gitconfig',
    '.gitignore',
    '.hgrc',
    '.vimrc', 
    '.zshrc'
  ].each do |dotfile|
    linkfile dotfile, dotfile 
  end

end

task :default => [ :install ] do end

def linkdir(dotfile, location)
  create_link "#{dotfile}/", location
end

def linkfile(dotfile, location)
  create_link dotfile, location
end

def create_link(dotfile, location)
    system "ln -Ffsv #{Dir.pwd}/#{dotfile} ~/#{location}"
end
