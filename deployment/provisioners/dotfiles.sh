#!/bin/sh

# sudo chsh -s /bin/zsh vagrant # Otherwise it asks for password.

cd

git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh

tarball="https://github.com/botanicus/dotfiles/tarball/master"
curl -L $tarball 2> /dev/null | tar -xzv --strip-components 1 --exclude={README.md,.editorconfig,.gitignore}
