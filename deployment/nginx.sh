#!/bin/sh

cat > /etc/nginx/sites-enabled/$1.conf << EOF
include /webs/$1/vhost.conf;
EOF
