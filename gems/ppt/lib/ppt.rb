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

  def self.config(key)
    path = File.join(self.root, 'config', "#{key}.json")
    JSON.parse(File.read(path)).reduce(Hash.new) do |buffer, (key, value)|
      buffer.merge(key.to_sym => value)
    end
  end
end
