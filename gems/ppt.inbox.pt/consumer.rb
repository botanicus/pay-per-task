#!/usr/bin/env ruby

require 'ppt'
require 'pipeline/plugin'

require_relative 'processor'

module PPT::PT
  class Consumer < Pipeline::Plugin
    QUEUES = {'inbox.pt' => 'inbox.pt.#'}

    def run
      puts "~ Listening for data ..."
      processor = PPT::PT::Processor.new(client)

      client.consumer('inbox.pt', 'inbox.pt.#') do |payload, header, frame|
        processor.process(payload, frame.routing_key)
      end
    end
  end
end

PPT::PT::Consumer.run(Dir.pwd)
