class PPT
  class Processor
    def initialize(client)
      @client = client
    end

    # $20 £20 €20
    def parse_price(title)
      match = title.match(/([£€$])(\d+)/)
      return match[2].to_i, match[1]
    end

    def emit(event, data)
      routing_key = "events.#{event}"
      puts "~ PUB #{routing_key}: #{data}"
      self.publish(data, routing_key)
    end

    def publish(data, routing_key)
      @client.exchange.publish(data, routing_key)
    end

    def process(payload, routing_key)
      payload = JSON.parse(payload)

      _, service, username = routing_key.split('.')

      # TODO: do this only if the state is new.
      # new -> WIP
      # WIP -> done
      # done -> [accepted | rejected]
      story = self.build_story(service, username, payload)
      self.emit('stories.new', story.to_json)

      developer = self.build_developer(service, username, payload)
      self.emit('devs.new', developer.to_json)
    end
  end
end

require 'ppt/presenters'
require 'ppt/db'
