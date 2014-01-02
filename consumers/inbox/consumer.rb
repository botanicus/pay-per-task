#!/usr/bin/env bundle exec ruby -I../../lib

require 'json'
require 'ppt/client'

client = Client.register_hook

# Save everything to the disk, so anything can be replayed.
EM.run do
  EM.next_tick do
    client.on_open do
      client.subscribe do |payload|
        message = JSON.parse(message)
        service = routing_key.split('.').last
        path = File.join('payloads', service, message['username'], "#{timestamp}.json")
        File.open(path, 'w') do |file|
          file.puts(message['payload'])
        end
      end
    end
  end
end
