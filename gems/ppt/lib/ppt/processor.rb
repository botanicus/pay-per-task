require 'ppt/models'

class PPT
  class Processor
    CURRENCY_MAP = {'$' => 'USD', '£' => 'GBP', '€' => 'EUR'}

    # CURRENCY_MAP['$']   # => 'USD'
    # CURRENCY_MAP['USD'] # => 'USD'
    CURRENCY_MAP.default_proc = Proc.new do |hash, key|
      hash.has_key?(key) ? hash[key] : key
    end

    def initialize(client)
      @client = client
    end

    # $20 £20 €20
    # @returns title, currency, price
    # TODO: What if given currency isn't supported?
    def parse_title(title)
      match = title.match(/^(([£€$]|(GBP|EUR|USD) )?(\d+)\s+)?(.+)$/)
      return match[5], CURRENCY_MAP[match[2]], match[4].to_i
    end

    # parse_title "Test"
    # parse_title "10 Test"
    # parse_title "GBP 10 Test"
    # parse_title "$10 Test"

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
