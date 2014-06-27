#!/usr/bin/env ruby

require 'bundler'

Bundler.setup

require 'ppt'
require 'json'
require 'pipeline/plugin'

module PPT::PT
  class Consumer < Pipeline::Plugin
    QUEUES = {'inbox.backup' => 'inbox.#'}

    def run
      client.consumer('inbox.backup', 'inbox.#') do |blob, header, frame|
        _, service, username = frame.routing_key.split('.')
        path = File.join('data', 'inbox', service, "#{username}.yml")
        FileUtils.mkdir_p(File.dirname(path))
        puts "~ Writing payload from #{frame.routing_key} to #{path}"

        begin
          # Leave out whitespace.
          blob = JSON.parse(payload).to_json

          # By saving a lot of small files, 5k requests consumed 20MB
          # of disk space (5k * 4kB). With one big file we only need
          # 4.2MB (when using the sample data from Pivotal Tracker).
          #
          # Insterestingly enough this actually IS valid YAML and we
          # can use YAML.load_documents(io) on it. So far there was
          # no need to escape the JSON as a string, it gets properly
          # parsed as YAML.
          #
          # At least on MRI. YAML.load_documents on Rubinius raise
          # an exception.
          File.open(path, 'a') do |file|
            file.puts("---\n#{blob}")
          end
        rescue Exception => error
          # No error should really happen, but we cannot
          # pressume that the JSON is valid for instance.
          puts "~ ERROR #{error.class} #{error.message}"
        end
      end
    end
  end
end

PPT::PT::Consumer.run(PPT.root)
