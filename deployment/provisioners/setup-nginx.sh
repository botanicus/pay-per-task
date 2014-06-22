#!/bin/sh

sudo rm /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/sites-enabled/$1.conf <<EOF
include /webs/$1/webs/vhost.dev.conf;
EOF

# Patch Nginx Upstart script to start when the main Vagrant
# directory is mounted. This is already in the base box,
# but we changed the location from /vagrant to a custom path.
sudo ruby -pi -e 'sub(/MOUNTPOINT=.+/, %Q{MOUNTPOINT="/webs/ppt"})' /etc/init/nginx.conf

sudo start nginx
