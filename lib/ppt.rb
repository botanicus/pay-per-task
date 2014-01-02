class PPT
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
end

class NoPriceDetectedError < StandardError
  def initialize(title)
    super("No price detected in: #{title.inspect}")
  end
end

class Story
  attr_reader :service, :username
  attr_reader :id, :price, :currency, :link

  def initialize(redis, service, username, id, price, currency, link)
    @service, @username = service, username
    @id, @price, @currency, @link = id, price, currency, link
  end

  def key
    "stories.#{self.service}.#{self.username}.#{self.id}"
  end

  def value
    #
  end

  def save
    @redis.set(self.key, self.value)
  end
end

require 'ppt/client'
