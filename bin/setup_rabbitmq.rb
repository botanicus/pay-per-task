#!/usr/bin/env ruby
# How to make sure this runs with the correct version of ruby?

require 'json'

def sh(command)
  puts "~ #{command}"
  puts %x(#{command})
  puts
end

path   = "/webs/#{ARGV.first}/config/amqp.json"
config = DATA.read
opts   = JSON.parse(config)

File.open(path, 'w') do |file|
  file.puts(config)
end

sh "rabbitmqctl add_user ppt #{opts['user']}"
sh "rabbitmqctl add_vhost #{opts['vhost']}"
sh "rabbitmqctl set_permissions -p #{opts['vhost']} #{opts['user']} '.*' '.*' '.*'"

__END__
{
  "vhost":    "ppt",
  "user":     "ppt",
  "password": "ae28cd87adb5c385117f89e9bd452d18"
}
