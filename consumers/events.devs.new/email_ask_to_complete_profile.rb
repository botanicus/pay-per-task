#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt'
require 'mail'
require 'mustache'

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    client.subscribe('events.devs.new') do |payload, header, frame|
      presenter = PPT::Presenters::Developer.new(JSON.parse(payload))
      scope = {name: presenter.name, user_activation_page: 'LINK'}


      email = Mail.new do
        from    'james@101ideas.cz'
        to      presenter.email
        subject "Welcome to PPT :)"
        body    Mustache.render(DATA.read, scope)
      end

      # Send to email queue.
      client.send('emails.devs.new', email.to_s)
    end
  end
end

__END__
Hi {{name}},

you have been added to PPT. PPT is ...

Please go to {{user_activation_page}} and activate your profile.
Once you're done with that, you'll be able to keep track of all your
invoices, their due dates and their status.

In the future there will be page of transactions, you'll be getting
your money without needing to worry about chasing your clients anymore.
Yaks!

Cheers,

James
Founder of PPT
