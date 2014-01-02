class Processor
  def self.process(payload, routing_key)
    _, service, username = routing_key.split('.')
  end
end
