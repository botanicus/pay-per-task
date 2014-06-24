#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'ppt'
require 'ppt/client'
require_relative 'processor'

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."
    processor = PPT::PT::Processor.new(client)

    client.consumer('inbox.pt', 'inbox.pt.#') do |payload, header, frame|
      processor.process(payload, frame.routing_key)
    end
  end
end
