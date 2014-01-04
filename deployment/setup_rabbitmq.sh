#!/bin/sh

rabbitmqctl add_user ppt ae28cd87adb5c385117f89e9bd452d18
rabbitmqctl add_vhost ppt
rabbitmqctl set_permissions -p ppt ppt '.*' '.*' '.*'
