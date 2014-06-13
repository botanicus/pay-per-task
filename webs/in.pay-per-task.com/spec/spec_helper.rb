require 'http'

module HttpApi
  module Extensions
    def self.extended(base)
      base.class_eval do
        def request_method
          self.class.description.split(' ').first
        end

        def request_path
          self.class.description.split(' ').last.split('/').
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
            HTTP.send(request_method.downcase, url)
          else
            # puts "~ #{request_method} data: #{request_data.inspect}"
            HTTP.send(request_method.downcase, url)
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

require 'redis'
require 'json'

RSpec.configure do |config|
  config.extend(HttpApi::Extensions)

  config.add_setting(:base_url)
  config.base_url = 'http://in.pay-per-task.dev'

  config.before(:all) do
    redis = Redis.new(driver: :hiredis)

    redis.flushdb
    redis.hmset('users:botanicus', :auth_key, 'Wb9CdGTqEr7msEcPBrHPinsxRxJdM')
  end
end
