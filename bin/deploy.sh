#!/bin/sh

# This script deploys and redeploys remote server.
# It is NOT meant to run with Vagrant, neither it
# is meant to run ON the remote server.

SCRIPTS=(deployment/git-deploy.sh)
PROJECT=ppt

run () {
  ssh server "cd /root/deployment/$PROJECT && chmod +x $1 && $remote_path ${@:2}"
}

echo "Copying deployment scripts"
ssh server "mkdir -p /root/deployment/$PROJECT"
rsync deployment bin/provision.rb -av --delete --exclude veewee server:/root/deployment/$PROJECT

echo "Creating /etc/provisioners"
ssh server "test -d /etc/provisioners || mkdir /etc/provisioners"

if [ "$1" = "--redeploy" ]; then
  echo "Redeploying ${@:2}"
  run provision.rb ${@:2} --redeploy
else
  echo "Running additional deployment scripts"
  run provision.rb $SCRIPTS

  git push
  git push origin master:deployment

  # for repo in *matcherapp.com; do
  #   cd $repo
  #   git push
  #   git push origin master:deployment
  #   cd -
  # done
fi
