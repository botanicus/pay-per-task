#!/usr/bin/env ruby

# This script runs LOCALLY on either remote server or VM.

require 'yaml'
require 'fileutils'

PROJECT = 'ppt' # TODO: this should NOT be here!

config_path = "/etc/provisioners/#{PROJECT}.yml"

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
        system(provisioner)
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
