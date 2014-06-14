require 'json'

class PPT
  class NoPriceDetectedError < StandardError
    def initialize(title)
      super("No price detected in: #{title.inspect}")
    end
  end

  USERS ||= {'botanicus' => '5c32e90nsf10'}

  def self.root
    File.expand_path('/webs/ppt')
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
    path = File.join(self.root, 'config', "#{key}.json")
    JSON.parse(File.read(path)).reduce(Hash.new) do |buffer, (key, value)|
      buffer.merge(key.to_sym => value)
    end
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
end


require 'ppt/presenters'
require 'ppt/db'
