#!/usr/bin/env bundle exec ruby -Ilib

require 'mail'
require 'mustache'

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."

    client.subscribe('events.devs.new') do |payload, header, frame|
      presenter = PPT::Presenters::Developer.new(JSON.parse(payload))
      scope = {name: @presenter.name, user_activation_page: @presenter.user_activation_page}


      email = Mail.new do
        from    'james@101ideas.cz'
        to      @presenter.email
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

you have been added to PPT. Please go to {{user_activation_page}} and fill
in your your profile in order to get automated payments to your bank account.

Cheers,

James
Founder of PPT
