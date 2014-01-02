#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt/client'

client = Client.register_hook

EM.run do
  EM.next_tick do
    client.on_open do
      puts "~ Publishing random data ..."
      services = ['pt', 'jira']
      payload  = {id: rand(10_000)}.to_json
      client.publish({service: services[rand(2)], username: 'botanicus', payload: payload}.to_json)

      client.disconnect { EM.stop }
    end
  end
end
