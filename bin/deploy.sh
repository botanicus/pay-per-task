#!/bin/sh

# This script deploys and redeploys remote server.
# It is NOT meant to run with Vagrant, neither it
# is meant to run ON the remote server.

~/Dropbox/Code/deployment/server/bin/deployer.sh ppt deployment/setup_rabbitmq.sh deployment/nginx.sh deployment/ruby.sh deployment/git-deploy.sh

git push --set-upstream origin master
git config alias.deploy 'push origin master:deployment'
git deploy
