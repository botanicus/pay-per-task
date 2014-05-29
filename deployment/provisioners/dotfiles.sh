#!/bin/sh

sudo chsh -s /bin/zsh vagrant # Otherwise it asks for password.
curl https://raw.githubusercontent.com/botanicus/dotfiles/master/install.rb 2> /dev/null | ruby

tee -a ~/.zshrc <<EOF
alias restart="sudo restart"
alias start="sudo start"
alias stop="sudo stop"

source /etc/environment
source /etc/profile.d/rubinius.sh

cd /webs/$1
EOF
