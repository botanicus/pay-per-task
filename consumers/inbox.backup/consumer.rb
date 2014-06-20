#!/usr/bin/env ruby -I../lib -rbundler/setup ./consumer.rb

require 'ppt'
require 'ppt/client'
require 'securerandom'

require 'json'

unless Dir.pwd == PPT.root
  puts "~ Changing from #{Dir.pwd} to #{PPT.root}"
  Dir.chdir(PPT.root)
end

client = PPT::Client.register_hook

# Save everything to the disk, so anything can be replayed.
EM.run do
  EM.next_tick do
    client.on_open do
      puts "~ Listening for data ..."

      client.consumer('inbox.#') do |payload, header, frame|
        _, service, username = frame.routing_key.split('.')
        path = File.join('data', 'inbox', service, username, "#{Time.now.to_i}-#{SecureRandom.hex}.json")
        FileUtils.mkdir_p(File.dirname(path))
        puts "~ Writing payload from #{frame.routing_key} to #{path}"

        begin
          json = JSON.parse(payload).to_json

          File.open(path, 'w') do |file|
            file.puts(json)
          end
        rescue Exception => error
          # No error should really happen, but we cannot
          # pressume that the JSON is valid for instance.
          puts "~ ERROR #{error.class} #{error.message}"
        end
      end
    end
  end
end
