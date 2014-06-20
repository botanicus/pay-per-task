require 'bundler'
Bundler.setup(:default, :test)

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
          if example.metadata[:amqp]

            # http://rubybunny.info/articles/connecting.html
            amqp_connection = Bunny.new(RSpec.configuration.amqp_config)
            PPT::SpecHelper.set_better_client_name(amqp_connection, name)

            amqp_connection.start

            channel = amqp_connection.create_channel
            @channel = channel
            @queue = channel.queue('').bind('amq.topic', routing_key: '#')

            example.run

            amqp_connection.close
          end
        end
      end
    end
  end
end
