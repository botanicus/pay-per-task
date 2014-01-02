#!/usr/bin/env bundle exec ruby -Ilib

# NOTE: This might be taken care of by some of the existing invoicing services.

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
        subject "Invoice"
        body    Mustache.render(DATA.read, scope)
      end

      # Send to email queue.
      client.send('emails.invoice', email.to_s)
    end
  end
end

__END__
Hi {{boss}},

here's invoice from {{name}} for amount of {{currency}}{{price}} for his work on {{story}}.

Cheers,

James
Founder of PPT
