#!/bin/sh

cat > /etc/nginx/sites-enabled/$1.conf << EOF
include /webs/$1/vhost.conf;
EOF

stop nginx 2> /dev/null
start nginx
