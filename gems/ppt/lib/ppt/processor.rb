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

    def parse_title(title)
      title.match(/[£€$]\d+ (.+)/)[1]
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

      _, service, company = routing_key.split('.')

      self.ensure_story_exists(company, payload)
      self.ensure_developer_exists(company, payload)
    rescue JSON::ParserError => error
      # Log it and ignore, there's not much we can do.
      STDERR.puts("~ ERROR #{error.class} #{error.message}")
    end
  end
end

require 'ppt/models'
