#!/usr/bin/env bundle exec rackup -s thin -p 4000

require 'json'

def serve_file(path)
  puts "~ Serving #{path}\n\n"
  content = File.read(path)
  headers = {'Content-Length' => content.bytesize.to_s}

  case path.split('.').last
  when 'js'
    headers['Content-Type'] = 'application/javascript'
  when 'css'
    headers['Content-Type'] = 'text/css'
  end

  [200, headers, [content]]
end

def subscribe(env)
  params = JSON.parse(env['rack.input'].read)
  puts "~ New subscription: #{params.inspect}\n\n"
  [201, Hash.new, []]
end

run Proc.new { |env|
  path = File.join('content', env['PATH_INFO'])
  path = 'content/app.html' if path == 'content/'
  if env['REQUEST_METHOD'] == 'GET'
    if File.exist?(path)
      serve_file(path)
    else
      serve_file('content/app.html')
    end
  elsif env['REQUEST_METHOD'] == 'POST' && env['PATH_INFO'] == '/subscribe'
    subscribe(env)
  end
}
