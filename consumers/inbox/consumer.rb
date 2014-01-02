#!/usr/bin/env bundle exec ruby -Ilib

# ESSENTIAL SERVICE, don't screw with me!

require 'json'
require 'ppt'

unless Dir.pwd == PPT.root
  puts "~ Changing from #{Dir.pwd} to #{PPT.root}"
  Dir.chdir(PPT.root)
end

client = PPT::Client.register_hook

# Save everything to the disk, so anything can be replayed.
EM.run do
  EM.next_tick do
    client.on_open do
      client.subscribe('inbox') do |payload, header, frame|
        _, service, username = frame.routing_key.split('.')
        path = File.join('data', 'inbox', service, username, "#{Time.now.to_i}.json")
        FileUtils.mkdir_p(File.dirname(path))
        puts "~ Writing #{payload} to #{path}"
        File.open(path, 'w') do |file|
          file.puts(payload)
        end
      end
    end
  end
end
