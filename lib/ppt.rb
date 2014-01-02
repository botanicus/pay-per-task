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

  def self.ensure_at_root
    unless Dir.pwd == self.root
      puts "~ Changing from #{Dir.pwd} to #{self.root}"
      Dir.chdir(self.root)
    end
  end

  def self.async_loop(&block)
    PPT.ensure_at_root

    client = PPT::Client.register_hook

    EM.run do
      EM.next_tick do
        block.call(client)
      end
    end
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

  module Presenters
    class Entity
      EXPECTED_KEYS ||= [].sort

      attr_reader :values

      def initialize(service, username, **values)
        unless values.keys.sort == self.class::EXPECTED_KEYS
          raise ArgumentError.new("Expected keys: #{self.class::EXPECTED_KEYS.inspect}, got #{values.keys.sort.inspect}")
        end

        @values = values.merge(service: service, username: username)
      end

      def method_missing(name, *args, &block)
        if @values.has_key?(name)
          @values[name]
        else
          super(name, *args, &block)
        end
      end

      def respond_to_missing?(name, include_private = false)
        @values.has_key?(name) || super(name, include_private)
      end

      def to_json
        @values.to_json
      end
    end

    class Story < Entity
      # NOTE: Do NOT use ||=, otherwise Entity#EXPECTED_KEYS shall be utilised.
      EXPECTED_KEYS = [:id, :price, :currency, :link].sort
    end

    class Developer < Entity
      EXPECTED_KEYS = [:id].sort
    end
  end

  require 'redis'

  module DB
    def self.redis
      @redis ||= Redis.new
    end

    class Entity
      def initialize(presenter)
        @presenter = presenter
      end

      def values
        @presenter.values
      end

      def save
        self.values.each do |key, value|
          PPT::DB.redis.hset(self.key, key, value)
        end
      end
    end

    class Story < Entity
      def key
        "stories.#{@presenter.service}.#{@presenter.username}.#{@presenter.id}"
      end
    end

    class Developer < Entity
      def key
        "devs.#{@presenter.service}.#{@presenter.username}.#{@presenter.nickname}"
      end
    end
  end
end



require 'ppt/client'
