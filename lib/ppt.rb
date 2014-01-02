class PPT
  class NoPriceDetectedError < StandardError
    def initialize(title)
      super("No price detected in: #{title.inspect}")
    end
  end

  USERS ||= {'botanicus' => '5c32e90nsf10'}

  def self.root
    File.expand_path('../..', __FILE__)
  end

  def self.config(key)
    JSON.parse(File.read(File.join(self.root, 'config', "#{key}.json")))
  end

  def self.authenticate(username, auth_key)
    self::USERS[username] == auth_key
  end

  def self.supports_service?(service)
    self.consumers.include?("inbox.#{service}")
  end

  def self.consumers
    consumers_dir = File.join(self.root, 'consumers')
    Dir.glob("#{consumers_dir}/*").
      select { |path| File.directory?(path) }.
      map { |path| File.basename(path) }
  end

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
      @client.exchange.publish(data, routing_key)
    end

    def process(payload, routing_key)
      payload = JSON.parse(payload)

      _, service, username = routing_key.split('.')

      story = self.build_story(service, username, payload)
      self.emit('stories.new', story.to_json)

      developer = self.build_developer(service, username, payload)
      self.emit('devs.new', developer.to_json)
    end
  end

  class Entity
    EXPECTED_KEYS ||= [].sort

    attr_reader :values

    def initialize(service, username, **values)
      unless values.keys.sort == self.class::EXPECTED_KEYS
        raise ArgumentError.new("Expected keys: #{self.class::EXPECTED_KEYS.inspect}, got #{values.keys.sort.inspect}")
      end

      @values = values.merge(service: service, username: username)
    end

    def to_json
      @values.to_json
    end
  end

  class Story < Entity
    # NOTE: Do NOT use ||=, otherwise Entity#EXPECTED_KEYS shall be utilised.
    EXPECTED_KEYS = [:id, :price, :currency, :link].sort

    # def key
    #   "stories.#{self.service}.#{self.username}.#{self.id}"
    # end

    # def value
    #   #
    # end

    # def save
    #   @redis.set(self.key, self.value)
    # end
  end

  class Developer < Entity
    EXPECTED_KEYS = [:id].sort
  end
end



require 'ppt/client'
