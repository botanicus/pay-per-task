#!/bin/sh

# NOTE: On Vagrant we can keep guest (I think it was somehow
# useful for the management plugin, but I might be mistaken).
#sudo rabbitmqctl delete_user guest

sudo rabbitmqctl add_user ppt ae28cd87adb5c385117f89e9bd452d18
sudo rabbitmqctl add_vhost ppt
sudo rabbitmqctl set_permissions -p ppt ppt '.*' '.*' '.*'

# RabbitMQ Management Plugin.

# It seems to be broken, I can't log in as matcherapp.com ... try to update.
# rabbitmqctl set_permissions -p ppt ".*" ".*" ".*"

sudo rabbitmq-plugins enable rabbitmq_management

sudo restart rabbitmq-server
