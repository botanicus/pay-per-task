#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt'
require 'ppt/client'

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    # 1 Better support for organisations. Plus rename to organisations to make it obvious.
    # 2 Properly determine status and publish to events.stories.accepted (it needs dev, org and story).
    # 3 Generate invoice using prawn and save to FS.
    # 4 Publish to invoices.new
    # 5 Create a consumer listening bound on invoices.new which creates an email and sends it to the email queue.
    client.consumer('invoices', 'events.stories.accepted') do |blob, header, frame|
      #
    end
  end
end
