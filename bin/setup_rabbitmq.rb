#!/usr/bin/env bundle exec ruby

require 'json'

def sh(command)
  puts "~ #{command}"
  puts %x(#{command})
  puts
end

opts = JSON.parse(File.read(File.expand_path('../../config/amqp.json', __FILE__)))

sh "rabbitmqctl add_user ppt #{opts['user']}"
sh "rabbitmqctl add_vhost #{opts['vhost']}"
sh "rabbitmqctl set_permissions -p #{opts['vhost']} #{opts['user']} '.*' '.*' '.*'"

# Guest has permissions for everything.
sh "rabbitmqctl delete_user guest"
