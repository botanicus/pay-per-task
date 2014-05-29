#!/bin/sh

sudo rm /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/sites-enabled/$1.conf <<EOF
include /webs/$1/webs/vhost.dev.conf;
EOF
