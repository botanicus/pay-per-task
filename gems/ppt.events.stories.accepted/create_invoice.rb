#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt'
require 'ppt/client'

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    client.consumer('invoices', 'events.stories.accepted') do |blob, header, frame|
      #
    end
  end
end
