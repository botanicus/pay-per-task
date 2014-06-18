#!/bin/sh

# sudo chsh -s /bin/zsh vagrant # Otherwise it asks for password.

cd

git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh

if test -d dotfiles; then
  ./dotfiles/install.sh | sh
else
  tarball="https://github.com/botanicus/dotfiles/tarball/master"
  curl -L $tarball 2> /dev/null | tar -xzv --strip-components 1 --exclude={README.md,.editorconfig,.gitignore,install.sh,.ssh/config}
  #curl https://raw.githubusercontent.com/botanicus/dotfiles/master/.ssh/config >> ~/.ssh/config
fi

