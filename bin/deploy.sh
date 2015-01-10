#!/bin/zsh

# This script deploys and redeploys remote server.
# It is NOT meant to run with Vagrant, neither it
# is meant to run ON the remote server itself.
#
# It needs Ruby to run provision.rb.

# Usage:
# ./bin/deploy.sh
# ./bin/deploy.sh deployment/git-deploy.sh
# ./bin/deploy.sh --redeploy deployment/git-deploy.sh

PROJECT=ppt

deploy () {
  echo "~ Running deployer.sh $PROJECT $*"
  ~/Dropbox/Projects/OSS/deployment/server/bin/deployer.sh $PROJECT $*
}

if [[ $# -gt 0 ]]; then
  deploy $*
else
  deploy deployment/setup_rabbitmq.sh deployment/nginx.sh deployment/ruby.sh deployment/git-deploy.sh
fi

git push --set-upstream origin master
git config alias.deploy 'push origin master:deployment'
git deploy
