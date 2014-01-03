#!/usr/bin/env bundle exec ruby -Ilib

# Useful resource:
# http://stackoverflow.com/questions/12884711/how-to-send-email-via-smtp-with-rubys-mail-gem

require 'ppt'
require 'mail'

# TODO: Extract to settings file.
options = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: '101ideas.cz',
  user_name: 'james@101ideas.cz',
  password: '3ff5s0sgd4dg1gdsFffhsds5s2s58sf6',
  authentication: 'plain',
  enable_starttls_auto: true
}

# TEST DATA
# blob = Mail.new do
#   from    'james@101ideas.cz'
#   to      'test@101ideas.cz'
#   subject "Welcome to PPT :)"
#   body    "Hello World!"
# end.to_s
# TEST DATA


Mail.defaults do
  delivery_method :smtp, options
end

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    client.subscribe('emails') do |blob, header, frame|
      mail = Mail.new(blob)
      mail.deliver
    end
  end
end
