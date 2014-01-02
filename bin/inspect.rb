#!/usr/bin/env bundle exec ruby -Ilib

# This script creates second queue and binds it to
# the exchange. It never touches the 'production' queue.

require 'ppt/client'

client = Client.register_hook

EM.run do
  EM.next_tick do
    client.on_open do
      temporary_queue = AMQ::Client::Queue.new(client.connection, client.channel)

      temporary_queue.declare(false, false, false, true) do
        puts "~ Temporary queue #{temporary_queue.name.inspect} is ready"
      end

      temporary_queue.bind(client.exchange.name) do
        puts "~ Temporary queue #{temporary_queue.name} is now bound to #{client.exchange.name}"
      end

      client.subscribe do |payload|
        puts "~ Data received: #{payload}"
      end
    end
  end
end
