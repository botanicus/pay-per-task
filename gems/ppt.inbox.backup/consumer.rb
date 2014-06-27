#!/usr/bin/env ruby

# By this we add everything into $LOAD_PATH,
# but that doesn't matter, since we don't actually
# require gems from any other group than default,
# we only do it ad-hoc: require 'pry'; binding.pry
require 'bundler/setup'

require 'ppt'
require 'json'
require 'pipeline/plugin'

module PPT::Backup
  class Consumer < Pipeline::Plugin
    QUEUES = {'inbox.backup' => 'inbox.#'}

    def run
      client.consumer('inbox.backup', 'inbox.#') do |payload, header, frame|
        puts "~ ppt.inbox.backup consumer is up and running."

        _, service, username = frame.routing_key.split('.')
        path = File.join('data', 'inbox', service, "#{username}.yml")
        FileUtils.mkdir_p(File.dirname(path))
        puts "~ Writing payload from #{frame.routing_key} to #{path}"

        begin
          # Converting to JSON and back in order to leave out the
          # whitespace.
          minified_payload = JSON.parse(payload).to_json

          # By saving a lot of small files, 5k requests consumed 20MB
          # of disk space (5k * 4kB). With one big file we only need
          # 4.2MB (when using the sample data from Pivotal Tracker).
          #
          # Insterestingly enough this actually IS valid YAML and we
          # can use YAML.load_documents(io) on it. So far there was
          # no need to escape the JSON as a string, it gets properly
          # parsed as YAML.
          #
          # At least on Psych. Syck, the older YAML implementation
          # written by _why raises an exception. That's why we're
          # including psych gem in our Gemfile for tests when we
          # read the YAML. Psych is however the default on MRI.
          File.open(path, 'a') do |file|
            file.puts("---\n#{minified_payload}")
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

PPT::Backup::Consumer.run(PPT.root)
