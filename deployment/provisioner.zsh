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

# TODO: There is an alias for it now, see dotfiles.sh
reinstall_upstart_services
# sudo rm /etc/init/ppt.*.conf
# for file in /webs/ppt/upstart/*.conf; do
#   echo "~ Copying $file"
#   sudo cp -f $file /etc/init/
#   sudo ruby -pi -e 'sub(/^start on .+$/, "start on vagrant-mounted")' /etc/init/$(basename $file)
# done

cd /etc
sudo git add --all .
sudo git commit -m "After vagrant up." &> /dev/null

use_rubinius
echo "~ Using $(ruby -v)"

cd /webs/ppt/webs/api.pay-per-task.com
bundle install
sudo start ppt.webs.api

echo "\n\n== Environment =="
echo "PATH=$PATH"
echo "Ruby: $(ruby -v)"

echo "\n== Services =="
services_status
# for service in #{services.join(" ")}; do
#   echo "* $(status $service)"
# done

echo "\nUse [status|stop|start|restart] [service]."

echo "\nAll you need to know can be found on http://docs.pay-per-task.dev"
