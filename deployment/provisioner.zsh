#!/usr/bin/env zsh

source /etc/profile.d/ruby.sh
echo "~ Using $(ruby -v)"

cd /etc
sudo git add --all .
sudo git commit -m "Before vagrant up." &> /dev/null

cd /webs/ppt
./bin/provision.rb $argv

echo ""

sudo git add --all .
sudo git commit -m "After running provisioners." &> /dev/null

# Provisioners run, let's switch to ZSH.
source ~/.zshrc

reinstall_upstart_services

cd /etc
sudo git add --all .
sudo git commit -m "After vagrant up." &> /dev/null

use_rubinius
echo "~ Using $(ruby -v)"

bundle install

# Set up local paths to libraries in development.
link_gems

services=(api in)
for service in $services; do
  cd /webs/ppt/webs/$service.pay-per-task.com
  bundle install
  sudo start ppt.webs.$service
done

sudo start ppt.consumers.backup
sudo start ppt.consumers.pt
sudo start ppt.consumers.jira

echo "\n\n== Environment =="
echo "PATH=$PATH"
echo "Ruby: $(ruby -v)"

echo "\n== Services =="
services_status

echo "\nUse [status|stop|start|restart] [service]."

echo "\nAll you need to know can be found on http://docs.pay-per-task.dev"
