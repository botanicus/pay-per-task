#!/usr/bin/env bundle exec rackup -s thin -p 4000

def serve_file(path)
  puts "~ Serving #{path}"
  content = File.read(path)
  headers = {'Content-Length' => content.bytesize.to_s}

  case path.split('.').last
  when 'js'
    headers['Content-Type'] = 'application/javascript'
  end

  [200, headers, [content]]
end

run Proc.new { |env|
  path = File.join('content', env['PATH_INFO'])
  path = 'content/app.html' if path == 'content/'
  if File.exist?(path)
    serve_file(path)
  else
    serve_file('content/app.html')
  end
}
