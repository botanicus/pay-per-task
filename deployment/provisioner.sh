#!/usr/bin/env zsh

source /etc/profile.d/ruby.sh
echo "~ Using $(ruby -v)"

cd /etc
sudo git add --all .
sudo git commit -m "Before vagrant up." &> /dev/null

cd /webs/ppt
./deployment/bin/provision.rb $argv

echo ""

sudo git add --all .
sudo git commit -m "After running provisioners." &> /dev/null

# Provisioners run, let's switch to ZSH.
source ~/.zshrc

reinstall_upstart_services

cd /etc
sudo git add --all .
sudo git commit -m "After vagrant up." &> /dev/null

cd /webs/ppt
use_rubinius
echo "~ Using $(ruby -v)"

# Set up local paths to libraries in development.
for library_path in gems/oss.*; do
  gem=$(echo $library_path | awk -F. '{ print $2 }')
  bundle config local.$gem $library_path
done

bundle install

services=(api in)
for service in $services; do
  cd /webs/ppt/webs/$service.pay-per-task.com
  bundle install
  sudo start ppt.webs.$service
done

for service in /webs/ppt/gems/ppt.*(/); do
  cd $service
  bundle install
done

sudo start ppt.inbox.backup
sudo start ppt.inbox.pt
sudo start ppt.inbox.jira

echo "\n\n== Environment =="
echo "PATH=$PATH"
echo "Ruby: $(ruby -v)"

echo "\n== Services =="
services_status

echo "\nUse [status|stop|start|restart] [service]."

echo "\nAll you need to know can be found on http://docs.pay-per-task.dev"
