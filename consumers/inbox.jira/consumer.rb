#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt'
require_relative 'processor'

unless Dir.pwd == PPT.root
  puts "~ Changing from #{Dir.pwd} to #{PPT.root}"
  Dir.chdir(PPT.root)
end

client = PPT::Client.register_hook

EM.run do
  EM.next_tick do
    client.on_open do
      puts "~ Listening for data ..."

      client.subscribe('inbox.jira') do |payload, header, frame|
        Processor.process(payload, frame.routing_key)
      end
    end
  end
end
