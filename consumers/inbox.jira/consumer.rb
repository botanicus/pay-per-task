#!/usr/bin/env bundle exec ruby -Ilib

require_relative 'processor'

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."
    processor = PPT::Jira::Processor.new(client)

    client.subscribe('inbox.jira') do |payload, header, frame|
      processor.process(payload, frame.routing_key)
    end
  end
end
