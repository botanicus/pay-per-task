#!/usr/bin/env bundle exec rackup -s Puma -p 7000

# WebHooks API POSTs to:
# https://in.ppt.com/jira/botanicus/5c32e90nsf10

# This should ONLY put it to the queue, nothing less, bare bones, nothing more.
# The authentication shall happen in the next step.

SUPPORTED_SERVICES = ['pt', 'jira']

require 'redis'
require 'json'
require 'bunny'

redis = Redis.new(driver: :hiredis)

def read_amqp_config(relative_path)
  config_path = File.expand_path(relative_path, __FILE__)
  JSON.parse(File.read(config_path)).reduce(Hash.new) do |buffer, (key, value)|
    buffer.merge(key.to_sym => value)
  end
end

# Change the name so we can make sense of RabbitMQ Management Plugin connections.
# TODO: This deserves PR.
def set_better_client_name(amqp_connection, name)
  client_properties = amqp_connection.instance_variable_get(:@client_properties)
  client_properties[:product] = name
end

amqp_config = read_amqp_config('../../../config/amqp.json')
puts "~ Establishing AMQP connection #{amqp_config.inspect}."
amqp_connection = Bunny.new(amqp_config)
set_better_client_name(amqp_connection, 'in:rack')

amqp_connection.start

channel  = amqp_connection.create_channel
exchange = channel.topic('amq.topic')

run lambda { |env|
  if env['REQUEST_METHOD'] == 'POST' && env['PATH_INFO'].match(%r{^/([\w\d]+)/([\w\d]+)/([\w\d]+)$})
    service, username, auth_key = $1, $2, $3
    if SUPPORTED_SERVICES.include?(service)
      if redis.hget("users:#{username}", :auth_key) == auth_key
        routing_key = "inbox.#{service}.#{username}"
        exchange.publish(env['rack.input'].read, routing_key: routing_key)
        [201, Hash.new, Array.new]
      else
        message = "Unauthorised: #{username.inspect} with #{auth_key.inspect}.\n"
        [401, {'Content-Type' => 'text/plain', 'Content-Length' => message.bytesize.to_s}, [message]]
      end
    else
      message = "Invalid reqest: service #{service.inspect} isn't supported. Supported services are #{SUPPORTED_SERVICES.join(', ')}\n"
      [400, {'Content-Type' => 'text/plain', 'Content-Length' => message.bytesize.to_s}, [message]]
    end
  elsif env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/'
    message = "PPT is running. Yaks!\n"
    [200, {'Content-Type' => 'text/plain', 'Content-Length' => message.bytesize.to_s}, [message]]
  else
    message = "Invalid request: #{env['REQUEST_METHOD']} #{env['PATH_INFO'].inspect}.\n"
    [404, {'Content-Type' => 'text/plain', 'Content-Length' => message.bytesize.to_s}, [message]]
  end
}
