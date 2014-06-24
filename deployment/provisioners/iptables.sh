#!/bin/sh

# Without this our Redis clan be wiped out and so can be our RabbitMQ.
# redis-cli -h the.host FLUSHDB # Whops, sorry bro ...

# This can be fixed in two ways:
# Change redis.conf: bind 127.0.0.1 -> bind 0.0.0.0
# There's a solution for RabbitMQ as well:
# http://serverfault.com/questions/235669/how-do-i-make-rabbitmq-listen-only-to-localhost
#
# What if I want to allow multiple IPs though?
# And besides, sooner or later I'm going to write
# some iptables rules anyway, so I might as well
# start right now.
#
# Besides with iptables I don't have to figure out
# how to do it for every other service I install.
#
# Alright, ready?

# Flush all rules in the default table (filter).
sudo iptables -F
sudo iptables -X

sudo iptables -t filter --list
exit

# Set default filter policy.
sudo iptables -P INPUT DROP
#sudo iptables -P OUTPUT DROP
#sudo iptables -P FORWARD DROP
# all ports except 80 port tcp, 53 udp(dns), 67,68 udp(dhcp).
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT

# Allow unlimited traffic on loopback
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
