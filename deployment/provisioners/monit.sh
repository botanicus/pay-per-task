#!/bin/sh

sudo apt-get install monit

sudo /etc/init.d/monit stop
sudo update-rc.d monit disable

sudo tee /etc/init/monit.conf <<EOF
# Shamefully stolen from http://mmonit.com/wiki/Monit/Upstart

description "Monit service manager"

limit core unlimited unlimited

start on vagrant-mounted MOUNTPOINT="/webs/ppt"
stop on runlevel [!2345]

expect daemon
respawn

exec /usr/bin/monit -c /etc/monit/monitrc

pre-stop exec /usr/bin/monit -c /etc/monit/monitrc quit
EOF

sudo mv /etc/monit/monitrc /etc/monit/monitrc.original

sudo tee /etc/monit/monitrc <<EOF
# Don't forget to run sudo monit reload after any change.
# If I'm not mistaken, restarting the daemon through Upstart
# ain't enough. Weird, right?
#
# This is the default setup.

# All paths MUST BE FULLY QUALIFIED, starting with '/'.

set daemon 120
set logfile /var/log/monit.log
set idfile /var/lib/monit/id
set statefile /var/lib/monit/state

set eventqueue
    basedir /var/lib/monit/events # set the base directory where events will be stored
    slots 100

include /etc/monit/conf.d/*

# EDITS
# See the Monit Wiki if you want to enable SSL for the web server.
set httpd port 2812 and
    #use address localhost  # only accept connection from localhost
    #allow localhost        # allow localhost to connect to the server and
    allow admin:monit      # require user 'admin' with password 'monit'
    #allow @monit           # allow users of group 'monit' to connect (rw)
    #allow @users readonly  # allow users of group 'users' to connect readonly

include /webs/ppt/deployment/monit/*
EOF

sudo start monit
sudo monit start all
