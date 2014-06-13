#!/usr/bin/env bundle exec ruby -Ilib

require 'ppt'
require 'ppt/client'

class PPT
  module Jira
    class Processor < PPT::Processor
      def build_story(service, username, payload)
        id    = payload['issue']['id']
        link  = payload['issue']['self']
        title = payload['issue']['fields']['summary']
        price, currency = self.parse_price(title)

        # OK, status is tricky.
        # We can only see when it CHANGES, which *would* be fine,
        # except that we can't tell what the status is if its newly
        # integrated (and hence we don't have given issue in the DB).
        #
        #
        # Possible solutions
        #
        # 1) Fetch using the API. That *migth* further complicates initial
        #    setup. Or maybe not, since this is going to be a Jira app.
        #
        # 2) We don't really care much about the actual status, only
        #    about the transition from finished to approved.
        status = payload['changelog']['items'].find do |item|
          item['field'] == 'status' # TODO: I don't know the name of the field.
        end

        if status && status['fromString'] == 'approved' && status['toString'] == 'approved' # && user has the permissions for that
          # TODO: do something.
        end

        # We might not want to skip any stories(?)
        # raise PPT::NoPriceDetectedError.new(title) if price.nil?

        PPT::Presenters::Story.new(service: service, username: username, id: id, price: price, currency: currency, link: link)
      end

      def build_developer(service, username, payload)
        email    = payload['user']['emailAddress']
        name     = payload['user']['displayName']
        nickname = payload['user']['name']

        PPT::Presenters::Developer.new(service: service, username: username, email: email, nickname: nickname, name: name)
      end
    end
  end
end

PPT.async_loop do |client|
  client.on_open do
    puts "~ Listening for data ..."
    processor = PPT::Jira::Processor.new(client)

    client.consumer('inbox.jira', 'inbox.jira.#') do |payload, header, frame|
      begin
        processor.process(payload, frame.routing_key)
      rescue Exception => error
        # Exception queue(?) and not ack
        raise error
      # else
        # ack it
      end
    end
  end
end
