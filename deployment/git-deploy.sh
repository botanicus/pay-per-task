#!/bin/sh

PROJECT="$1"

# Helpers.
copy () {
  source="deployment/data/post-receive/$2"
  target="/repos/$1/hooks/$3"

  echo "$2 -> /repos/$1/hooks/$3"

  if test -d $source; then
    rm -rf $target
    cp -r $source $target
  else
    cp $source $target
  fi
}

make_hook_executable () {
  target="/repos/$1/hooks/post-receive"

  echo "chmod +x $target"
  chmod +x $target
}

mkdir /repos /webs 2> /dev/null

# Top-level repo.
git init --bare /repos/$PROJECT
copy $PROJECT post-receive.zsh post-receive
copy $PROJECT functions functions
make_hook_executable $PROJECT
