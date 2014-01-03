#!/usr/bin/env bundle exec ruby -Ilib

# Useful resource:
# http://stackoverflow.com/questions/12884711/how-to-send-email-via-smtp-with-rubys-mail-gem

require 'ppt'
require 'ppt/client'

require 'mail'

puts "~ Starting with configuration: #{PPT.config('smtp')}"

Mail.defaults do
  delivery_method :smtp, PPT.config('smtp')
end

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    client.consumer('emails', 'emails.#') do |blob, header, frame|
      mail = Mail.new(blob)
      puts "~ Sending email to #{mail.to}"
      mail.deliver
    end
  end
end
