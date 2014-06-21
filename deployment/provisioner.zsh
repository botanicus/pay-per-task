#!/usr/bin/env zsh

# Restart Nginx.
# The damn vagrant-mounted event is emitted every time an NFS
# folder is mounted. So far it's been a problem only (once)
# after vagrant up. It was fine when I run vagrant reload.
# TODO: Investigate.
sudo restart nginx

source /etc/profile.d/ruby.sh
echo "~ Using $(ruby -v)"

cd /etc
sudo git add --all .
sudo git commit -m "Before vagrant up." &> /dev/null

# TODO: Fix this, what the hell?
sudo restart rabbitmq-server
sleep 2.5

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

# Set up local paths to libraries in development.
for gempath in /webs/ppt/gems/*(/); do
  gem=$(basename $gempath)
  bundle config local.$gem $gempath
done

services=(api in)
for service in $services; do
  cd /webs/ppt/webs/$service.pay-per-task.com
  bundle install
  sudo start ppt.webs.$service
done

consumers=(inbox.backup inbox.pt inbox.jira)
for consumer in $consumers; do
  cd /webs/ppt/consumers/$consumer
  bundle install
  sudo start ppt.consumers.$consumer
done

echo "\n\n== Environment =="
echo "PATH=$PATH"
echo "Ruby: $(ruby -v)"

echo "\n== Services =="
services_status

echo "\nUse [status|stop|start|restart] [service]."

echo "\nAll you need to know can be found on http://docs.pay-per-task.dev"
