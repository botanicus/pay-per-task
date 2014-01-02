#!/usr/bin/env bundle exec ruby -I../in/lib

require 'json'
require 'ppt/client'

client = Client.register_hook

EM.run do
  EM.next_tick do
    client.on_open do
      puts "~ Listening for data ..."

      client.subscribe do |payload|
        Receiver.process(payload)
      end
    end
  end
end
