#!/usr/bin/env bundle exec ruby

require 'json'
require 'nokogiri'

routes = JSON.parse(DATA.read)

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

__END__

[
  {
    "path": "/",
    "templateUrl": "templates/business-owners.html",
    "title": "PPT: The secret weapon in MOTIVATING your IT team!"
  },

  {
    "path": "/contractors",
    "templateUrl": "templates/contractors.html",
    "title": "PPT: GET PAID for your work in REALTIME!"
  },

  {
    "path": "/pricing",
    "templateUrl": "templates/pricing.html",
    "title": "PPT: Pricing"
  },

  {
    "path": "/about-us",
    "templateUrl": "templates/about-us.html",
    "title": "PPT: About Us"
  },

  {
    "path": "/contact",
    "templateUrl": "templates/contact.html",
    "title": "PPT: Contact"
  },

  {
    "path": "/sign-up",
    "templateUrl": "templates/sign-up.html",
    "title": "PPT: Sign up now!"
  }
]
