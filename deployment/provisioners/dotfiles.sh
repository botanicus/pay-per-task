#!/bin/sh

# export HOME=/home/vagrant

sudo chsh -s /bin/zsh vagrant # Otherwise it asks for password.
curl https://raw.githubusercontent.com/botanicus/dotfiles/master/install.rb 2> /dev/null | ruby

tee -a ~/.zshrc <<EOF
cd /webs/$1
EOF
