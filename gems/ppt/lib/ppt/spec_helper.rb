require 'ppt'
require 'bunny'

class PPT
  class SpecHelper
    def self.set_better_client_name(amqp_connection, name)
      client_properties = amqp_connection.instance_variable_get(:@client_properties)
      client_properties[:product] = name
    end

    def self.enforce_vagrant
      unless File.exist?('/etc/vagrant_box_build_time')
        abort 'Integration tests are meant to run within Vagrant.'
      end
    end

    def self.configure(name)
      RSpec.configure do |config|
        config.add_setting(:amqp_config)
        config.amqp_config = PPT.config('amqp')

        config.around do |example|
          # This requires let(:redis) { Redis.new(driver: :hiredis) }.
          clear_redis = Proc.new { |&block|
            puts '~ Redis FLUSHDB.'
            redis.flushdb
            redis.hmset('users.ppt',
              'auth_key', 'Wb9CdGTqEr7msEcPBrHPinsxRxJdM',
              'pt.api_key', '78525a130a030829876309975267aa6a',
              'email', 'james@101ideas.cz',
              'created_at', '2014-06-29T15:13:37+02:00')
            block.call
            redis.flushdb
          }

          amqp = Proc.new { |&block|
            puts '~ Connecting to AMQP.'
            # http://rubybunny.info/articles/connecting.html
            amqp_connection = Bunny.new(RSpec.configuration.amqp_config)
            PPT::SpecHelper.set_better_client_name(amqp_connection, name)

            amqp_connection.start

            channel = amqp_connection.create_channel
            @channel = channel
            @queue = channel.queue('').bind('amq.topic', routing_key: '#')

            block.call

            amqp_connection.close
          }

          if example.metadata[:amqp] && ! example.metadata[:redis]
            amqp.call { example.run }
          elsif example.metadata[:amqp] && example.metadata[:redis]
            amqp.call { clear_redis.call { example.run } }
          elsif ! example.metadata[:amqp] && example.metadata[:redis]
            clear_redis.call { example.run }
          else
            example.run
          end
        end
      end
    end
  end
end
