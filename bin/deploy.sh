#!/bin/sh

# This script deploys and redeploys remote server.
# It is NOT meant to run with Vagrant, neither it
# is meant to run ON the remote server.

~/Dropbox/Code/deployment/server/bin/deployer.sh ppt deployment/git-deploy.sh

git push
git push origin master:deployment
