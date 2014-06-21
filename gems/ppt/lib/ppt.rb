require 'json'

class PPT
  class NoPriceDetectedError < StandardError
    def initialize(title)
      super("No price detected in: #{title.inspect}")
    end
  end

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
