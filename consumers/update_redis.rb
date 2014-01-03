#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt'
require 'ppt/client'

# This will save/update anything.
PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    # events.stories.new | events.stories.update
    client.consumer('db.new', 'events.*.*') do |payload, header, frame|
      name = frame.routing_key.split('.')[1]
      record_klass = PPT::DB.get_klass(name)
      record = record_klass.new(JSON.parse(payload))
      puts "~ Saving #{record.values.inspect} to the DB."
      record.save
    end
  end
end
