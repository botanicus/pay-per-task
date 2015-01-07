#!/bin/sh

# Methods of installing dotfiles differ,
# which is why you can write your own script
# that won't be checked in to the Git repo.
if test -x deployment/provisioners/dotfiles.local.sh; then
  ./deployment/provisioners/dotfiles.local.sh
else
  echo "~ Skipping dotfiles installation."
fi
