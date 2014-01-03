#!/usr/bin/env bundle exec ruby -Ilib

# This script creates second queue and binds it to
# the exchange. It never touches the 'production' queue.
#
# Usage: ./bin/inspect.rb 'inbox.#'

require 'ppt'
require 'ppt/client'

client = PPT::Client.register_hook

routing_key = ARGV.first || '#'

EM.run do
  EM.next_tick do
    client.on_open do
      temporary_queue = AMQ::Client::Queue.new(client.connection, client.channel)

      temporary_queue.declare(false, false, false, true) do
        puts "~ Temporary queue #{temporary_queue.name.inspect} is ready"
      end

      temporary_queue.bind(client.exchange.name, routing_key) do
        puts "~ Temporary queue #{temporary_queue.name} is now bound to #{client.exchange.name} with routing key #{routing_key}"
      end

      temporary_queue.consume(true) do |consume_ok|
        puts "Subscribed for messages routed to #{temporary_queue.name}, consumer tag is #{consume_ok.consumer_tag}, using no-ack mode"

        temporary_queue.on_delivery do |basic_deliver, header, payload|
          puts "~ #{basic_deliver.routing_key}: #{payload}"
        end
      end
    end
  end
end
