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

require 'ppt/client'
