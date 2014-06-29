# Run with bundle exec puma -C puma.config.rb

# http://rubybunny.info/articles/error_handling.html

threads 8, 32
workers 3
port 7000
preload_app!


# App preloading ... shall we use it or not? Basically what it
# does is it loads config.ru and then it forms n-times. Useful
# for starting up quickly when there is a lot of workers.
#
# Because of the nature of it, all the connections should be
# established here.
#
# On the other hand, preloading doesn't work with phased restart.
#
# More here: https://github.com/puma/puma

on_worker_boot do
  def read_amqp_config(relative_path)
    config_path = File.expand_path(relative_path, __FILE__)
    JSON.parse(File.read(config_path)).reduce(Hash.new) do |buffer, (key, value)|
      buffer.merge(key.to_sym => value)
    end
  end

  # Change the name so we can make sense of RabbitMQ Management Plugin connections.
  # TODO: This deserves PR.
  def set_better_client_name(amqp_connection, name)
    client_properties = amqp_connection.instance_variable_get(:@client_properties)
    client_properties[:product] = name
  end

  amqp_config = read_amqp_config('../../../config/amqp.json')
  puts "~ Establishing AMQP connection #{amqp_config.inspect}."
  amqp_connection = Bunny.new(amqp_config)
  set_better_client_name(amqp_connection, "puma:in:#{rand(99)}")

  amqp_connection.start

  channel = amqp_connection.create_channel

  $exchange = channel.topic('amq.topic')
  $amqp_connection = amqp_connection

  # Make sure there's a persistent queue bound to amq.topic,
  # otherwise all our data might very well be going down the toilet.
  channel.queue(durable: true, auto_delete: false, nowait: true)

  $redis = Redis.new(driver: :hiredis)
end
