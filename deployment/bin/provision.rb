#!/usr/bin/env ruby

#
# THIS AIN'T REALLY RUNNING AT ALL!
# IT'S ~/Dropbox/Projects/OSS/deployment/server/bin/deployer.sh
# THAT DOES ALL THE MAGIC. I DON'T KNOW WHY IS THIS IN HERE IN THE FIRST PLACE!
#
# How should deployer.sh & provision.rb work?
#
# Should they be anywhere in path, just installed as dependencies?
# Should they be copied over here?
#
# Check list
#
# [ ] still works with Vagrant?
#

# This script runs LOCALLY on either a remote server or a VM.

require 'yaml'
require 'fileutils'

PROJECT = 'ppt' # TODO: this should NOT be here!

# config_path = "/etc/provisioners/#{PROJECT}.yml"
config_path = File.join(ENV['HOME'], "#{PROJECT}.yml") # otherwise we need sudo

save_config = lambda do |config = {run: Array.new}|
  File.open(config_path, 'w') do |file|
    file.puts(config.to_yaml)
  end
end

begin
  config = YAML::load(File.read(config_path))
rescue Errno::ENOENT
  save_config.call
  retry
end

opts = Hash.new
if ARGV.include?('--redeploy')
  opts[:redeploy] = true
  ARGV.delete('--redeploy')
end

begin
  ARGV.each do |provisioner|
    if File.exist?(provisioner) && File.executable?(provisioner)
      if (! config[:run].include?(provisioner)) || opts[:redeploy]
        system("#{provisioner} #{PROJECT}")
        if $?.exitstatus == 0
          puts "~ Provisioner #{provisioner} finished"
          config[:run] << provisioner unless config[:run].include?(provisioner)
        else
          puts "! Provisioner #{provisioner} failed!"
        end
      else
        puts "~ #{provisioner} run already, skipping."
      end
    elsif File.exist?(provisioner) && ! File.executable?(provisioner)
      puts "! Provisioner #{provisioner} isn't executable, skipping!"
    else
      puts "! File #{provisioner} doesn't exist!"
    end
  end
ensure
  save_config.call(config)
end
