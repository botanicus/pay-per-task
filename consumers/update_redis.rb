#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt'

# This will save/update anything.
PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    client.subscribe('events.devs.new') do |payload, header, frame|
      presenter = PPT::Presenters::Developer.new(JSON.parse(payload))
      record = PPT::DB::Developer.new(presenter)
      record.save
    end
  end
end
