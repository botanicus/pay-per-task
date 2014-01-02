#!/usr/bin/env bundle exec ruby -Ilib

require 'json'
require 'ppt'

unless Dir.pwd == PPT.root
  puts "~ Changing from #{Dir.pwd} to #{PPT.root}"
  Dir.chdir(PPT.root)
end

client = PPT::Client.register_hook

EM.run do
  EM.next_tick do
    client.on_open do
      puts "~ Listening for data ..."

      client.subscribe('inbox.pt.#') do |payload, header, frame|
        # TODO
        # Receiver.process(payload)
      end
    end
  end
end
