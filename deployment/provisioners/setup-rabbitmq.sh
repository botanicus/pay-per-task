#!/bin/sh

sudo rabbitmqctl add_user ppt ae28cd87adb5c385117f89e9bd452d18
sudo rabbitmqctl add_vhost ppt
sudo rabbitmqctl set_permissions -p ppt ppt '.*' '.*' '.*'

# RabbitMQ Management Plugin.

# It seems to be broken, I can't log in as matcherapp.com ... try to update.
# rabbitmqctl set_permissions -p ppt ".*" ".*" ".*"

sudo rabbitmq-plugins enable rabbitmq_management

# TODO: Move to the base box.
sudo tee /etc/init/rabbitmq-server.conf <<EOF
description "RabbitMQ Server"
author  "RabbitMQ"

start on runlevel [2345]
stop on runlevel [016]
respawn

exec /usr/sbin/rabbitmq-server > /var/log/rabbitmq/startup_log \
                              2> /var/log/rabbitmq/startup_err
post-start exec /usr/sbin/rabbitmqctl wait >/dev/null 2>&1
EOF
