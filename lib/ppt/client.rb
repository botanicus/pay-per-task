require 'eventmachine'
require 'amq/client'
require 'json'

# We aren't handling TCP connection lost, since this is running on the same machine.
# It means, however, that if we restart the broker, we have to restart all the services manually.
class PPT::Client
  def self.register_hook
    client = self.new

    # Next tick, so we can use it with Thin.
    EM.next_tick do
      puts "~ Connecting to RabbitMQ ..."
      opts = PPT.config('amqp')

      client.connect(adapter: 'eventmachine', user: opts['user'], password: opts['password'], vhost: opts['vhost'])

      # Set up signals.
      ['INT', 'TERM'].each do |signal|
        Signal.trap(signal) do
          puts "~ Received #{signal} signal, terminating."
          client.disconnect { EM.stop }
        end
      end

      client.declare_queue
    end

    client
  end

  attr_reader :connection, :channel, :exchange, :on_open_callbacks
  def connect(opts)
    @on_open_callbacks = Array.new
    @connection = AMQ::Client.connect(opts)
    @channel = AMQ::Client::Channel.new(@connection, 1)

    @connection.on_open do
      puts "~ Connected to RabbitMQ."

      @channel.open do
        self.on_open_callbacks.each do |callback|
          callback.call
        end
      end
    end
  end

  def exchange
    @exchange ||= AMQ::Client::Exchange.new(@connection, @channel, 'amq.topic')
  end

  def queues
    @queues ||= Hash.new
  end

  def declare_queue
    self.on_open do
      #self.consumers.each do |routing_key|
      queues = {'inbox.jira' => 'inbox.jira', 'inbox.pt' => 'inbox.pt', 'inbox' => 'inbox.#', 'events.devs.new' => 'events.devs.new', 'events.stories.accepted' => 'events.stories.accepted'}
      queues.each do |name, routing_key|
        queue = AMQ::Client::Queue.new(@connection, @channel, name)

        queue.declare(false, true, false, true) do
          puts "~ Queue #{queue.name.inspect} is ready"
        end

        queue.bind(self.exchange.name, routing_key) do
          puts "~ Queue #{queue.name} is now bound to #{self.exchange.name}"
        end

        self.queues[name] = queue
      end
    end
  end

  # TODO: This should be executed after both the queue and exchange is declared.
  def on_open(&block)
    self.on_open_callbacks << block
  end

  def publish(*args)
    self.exchange.publish(*args)
  end

  def subscribe(queue, &block)
    queue = self.queues[queue] if queue.is_a?(String)
    queue.consume(true) do |consume_ok|
      puts "Subscribed for messages routed to #{queue.name}, consumer tag is #{consume_ok.consumer_tag}, using no-ack mode"

      queue.on_delivery do |basic_deliver, header, payload|
        block.call(payload, header, basic_deliver)
      end
    end
  end

  def disconnect(&block)
    @connection.disconnect(&block)
  end
end
