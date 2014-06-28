#!/usr/bin/env ruby

# By this we add everything into $LOAD_PATH,
# but that doesn't matter, since we don't actually
# require gems from any other group than default,
# we only do it ad-hoc: require 'pry'; binding.pry
require 'bundler/setup'

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

PPT::PT::Consumer.run(PPT.root)
