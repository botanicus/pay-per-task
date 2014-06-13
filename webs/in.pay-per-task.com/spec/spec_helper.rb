require 'http'

# TODO: Extract this to a gem.
module HttpApi
  module Extensions
    def self.extended(base)
      base.class_eval do
        def description
          block = Proc.new do |metadata|
            if metadata[:description].match(/^(GET|POST|PUT|DELETE|OPTIONS|PATCH) (.+)$/)
              metadata[:description]
            else
              block.call(metadata[:parent_example_group])
            end
          end

          block.call(self.class.metadata)
        end

        def request_method
          self.description.split(' ').first
        end

        def request_path
          self.description.split(' ').last.split('/').
            map { |fragment| fragment.sub(/^:(.+)$/) { |match|
              # instance.send(match[1..-1])
              self.class.metadata[match[1..-1].to_sym]
            } }.join('/')
        end

        let(:attrs) do
          Hash.new
        end

        # let(:factory) do
        #   self.model.factory(attrs)
        # end

        let(:instance) do
          # TODO: maybe inheritance?
          if request_method == "POST"
            factory
          else
            factory.save
            puts "~ DB: #{factory.values}"
            factory
          end
        end

        let(:url) do
          [RSpec.configuration.base_url, request_path].join('')
        end

        # Rest client docs: https://github.com/rest-client/rest-client
        let(:response) do
          if ['GET', 'DELETE'].include?(request_method)
            # puts "~ #{request_method} #{request_path}"
            HTTP.send(request_method.downcase, url)
          else
            # puts "~ #{request_method} #{request_path} data: #{self.class.metadata[:data].inspect}"
            HTTP.send(request_method.downcase, url, body: self.class.metadata[:data])
          end
        end

        let(:response_data) do
          data = JSON.parse(response).reduce(Hash.new) do |buffer, (key, value)|
            buffer.merge(key.to_sym => value)
          end

          puts "Code: #{response.code}"
          puts "Data: #{data.inspect}"

          data
        end
      end
    end
  end
end


RSpec.configure do |config|
  config.extend(HttpApi::Extensions)

  config.add_setting(:base_url)
  config.base_url = 'http://in.pay-per-task.dev'

  # TODO: ?
  require 'json'
  config_path = File.expand_path('../../../../config/amqp.json', __FILE__)
  config.add_setting(:amqp_config)
  config.amqp_config = JSON.parse(File.read(config_path))

  require 'redis'

  config.before(:all) do
    redis = Redis.new(driver: :hiredis)

    redis.flushdb
    redis.hmset('users:botanicus', :auth_key, 'Wb9CdGTqEr7msEcPBrHPinsxRxJdM')
  end

  config.before(:all) do
    @amqp_connection = Bunny.new(RSpec.configuration.amqp_config)
    @amqp_connection.start
    channel = @amqp_connection.create_channel
    @queue = channel.queue('').bind('amq.topic', routing_key: '#')
  end

  config.after(:all) do
    @amqp_connection.close
  end
end
