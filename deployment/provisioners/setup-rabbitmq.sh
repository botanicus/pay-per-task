#!/bin/sh

rabbitmqctl add_user ppt ae28cd87adb5c385117f89e9bd452d18
rabbitmqctl add_vhost ppt
rabbitmqctl set_permissions -p ppt ppt '.*' '.*' '.*'

# RabbitMQ Management Plugin.

# It seems to be broken, I can't log in as matcherapp.com ... try to update.
rabbitmqctl set_permissions -p matcherapp.com guest ".*" ".*" ".*"

rabbitmq-plugins enable rabbitmq_management
/etc/init.d/rabbitmq-server restart
