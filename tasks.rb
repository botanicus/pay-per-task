#!/usr/bin/env bundle exec ruby

require 'json'
require 'nokogiri'

content = File.read(File.expand_path("../webs/pay-per-task.com/content/routes.js", __FILE__))
routes = JSON.parse(content.sub(/^ROUTES = /, ''))

layout_path = File.expand_path("../webs/pay-per-task.com/content/app.html", __FILE__)
layout = Nokogiri::HTML(File.read(layout_path))

routes.each do |route|
  puts "~ Processing #{route.inspect}"
  template_path = File.join(*File.split(route['templateUrl'])[1..-1])
  path = File.expand_path("../webs/pay-per-task.com/content/templates/#{template_path}", __FILE__)
  page = Nokogiri::HTML(File.read(path)) unless File.read(path).empty?

  # 1. Set the document title.
  puts "~ Setting title to '#{route['title']}'"
  layout.title = route['title']

  # 2. Substitute ng-include.
  layout.css('[ng-include]').each do |node|
    puts "~ Replacing ng-include by '#{node['ng-include'].value}'"
    require 'pry'; binding.pry
    raise "Not Implemented: support ng-include!"
  end

  # 3. Substitute ng-view.
  if page
    puts "~ Replacing ng-view by '#{route['templateUrl']}'"
    node = layout.at('[ng-view]')
    node.inner_html = page.at('html > body').inner_html
  else
    puts "~ Ignoring '#{route['templateUrl']}', it's empty"
  end

  File.open(File.expand_path("../webs/pay-per-task.com/content/prerender/#{template_path}", __FILE__), 'w') do |file|
    file.puts(layout.to_html)
  end

  puts
end
