#!/bin/sh

# $1 or Vagrant box IP 192.168.33.10
IP=${1-192.168.33.10}

# redis-cli -h $IP ping
nmap $IP -p 22,80,443
