#!/usr/bin/env bundle exec rackup -s Puma -p 7000

# WebHooks API POSTs to:
# https://in.ppt.com/jira/botanicus/5c32e90nsf10

# == IMPORTANT ==
# This should ONLY put it to the queue, nothing less, bare bones, nothing more.

SUPPORTED_SERVICES = ['pt', 'jira']

require 'bunny'

require 'redis'
require 'json'
require_relative 'responses'

def publish(payload, routing_key)
  $exchange.publish(payload, routing_key: routing_key)
rescue Bunny::ConnectionClosedError
  puts "~ Reconnecting to RabbitMQ ..."
  set_better_client_name($amqp_connection, "puma:in:#{rand(99)}")
  $amqp_connection.recover_from_network_failure
  retry
end

run lambda { |env|
  if env['REQUEST_METHOD'] == 'POST' && env['PATH_INFO'].match(%r{^/([\w\d]+)/([\w\d]+)/([\w\d]+)$})
    service, username, auth_key = $1, $2, $3
    if SUPPORTED_SERVICES.include?(service)
      if $redis.hget("users:#{username}", :auth_key) == auth_key
        routing_key = "inbox.#{service}.#{username}"
        publish(env['rack.input'].read, routing_key)
        [201, Hash.new, Array.new]
      else
        UnauthorisedResponse.new(username, auth_key).to_response
      end
    else
      InvalidRequestResponse.new(service, SUPPORTED_SERVICES).to_response
    end
  elsif env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/'
    SuccessfulGetResponse.new.to_response
  else
    NotFoundResponse.new.to_response
  end
}
