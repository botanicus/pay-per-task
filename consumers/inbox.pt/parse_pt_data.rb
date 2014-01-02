#!/usr/bin/env bundle exec ruby -Ilib

class PPT
  module PT
    class Processor < PPT::Processor
      # TODO
    end
  end
end

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."
    processor = PPT::PT::Processor.new(client)

    client.subscribe('inbox.pt') do |payload, header, frame|
      processor.process(payload, frame.routing_key))
    end
  end
end
