#!/usr/bin/env bundle exec ruby -I../../lib -S rackup -s thin -p 9999

# WebHooks API POSTs to:
# https://in.ppt.com/jira/botanicus/5c32e90nsf10

# ESSENTIAL SERVICE, don't screw with me!

require 'ppt'

client = PPT::Client.register_hook

run lambda { |env|
  if env['REQUEST_METHOD'] == 'POST' && env['PATH_INFO'].match(%r{^/([\w\d]+)/([\w\d]+)/([\w\d]+)$})
    service, username, auth_key = $1, $2, $3
    if PPT.supports_service?(service)
      if PPT.authenticate(username, auth_key)
        routing_key = "inbox.#{service}.#{username}"
        client.publish(env['rack.input'].read, routing_key)
        [201, Hash.new, Array.new]
      else
        message = "Unauthorised: #{username.inspect} with #{auth_key.inspect}.\n"
        [401, {'Content-Type' => 'text/plain', 'Content-Length' => message.bytesize.to_s}, [message]]
      end
    else
      message = "Invalid reqest: #{service.inspect} isn't supported.\n"
      [400, {'Content-Type' => 'text/plain', 'Content-Length' => message.bytesize.to_s}, [message]]
    end
  else
    message = "Invalid request: #{env['REQUEST_METHOD']} #{env['PATH_INFO'].inspect}.\n"
    [404, {'Content-Type' => 'text/plain', 'Content-Length' => message.bytesize.to_s}, [message]]
  end
}
