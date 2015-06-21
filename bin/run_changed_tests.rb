#!/usr/bin/env ruby

ENV['CI'] = 'true'

require 'json'
require 'open-uri'

# TODO: Don't just ADD projects, also delete them
# (or at least send a slack notification as a reminder).
# TODO: this is in ENV['CIRCLE_COMPARE_URL']
URL = 'https://circleci.com/api/v1/project'
PRJ = 'botanicus/pay-per-task'
TKN = 'b242fa5732d25efc8c4257180206342c9d5b404e'

# https://circleci.com/docs/api
stream = open("#{URL}/#{PRJ}?circle-token=#{TKN}")
data = JSON.parse(stream.read)
range = data[0]["compare"].split("/").last

# Codeship
# export previous_build_commit=$(curl https://codeship.com/api/v1/projects/83840.json?api_key=31624550ecd801322af5768767ec3f20 | ruby -rjson -ne 'puts JSON.parse($_)["builds"][-2]["commit_id"]')

# TODO: Dependencies (when the api changes, re-run frontend tests as well)
# unless ENV['previous_build_commit']
#   abort "You must set up environment variable previous_build_commit."
# end

ENV['ROOT'] = Dir.pwd

def find_build_script(dir)
  if File.exist?(File.join("#{dir}/build.sh"))
    dir
  elsif dir != '.'
    find_build_script(File.dirname(dir))
  end
end

# Find relevant, changed files.
# It's important to filter out irrelevant stuff,
# so we don't do unnecessary redeployments.
# TODO: this could be split into two things:
# 1. don't run tests 2. do run tests, but don't redeploy
# (i. e. when only tests and doc was committed).
files = %x{git diff --name-only #{range}}.split("\n")
ignore_list = ['README.md', '.gitignore', 'Rakefile', 'vhost.dev.conf', '.rspec']
ignored_files = files.select { |file| ignore_list.include?(File.basename(file)) }
files = files - ignored_files
puts "~ Changed files: #{files.inspect}"
puts "~ Ignored files: #{ignored_files.inspect}"

# Find changed subprojects.
dirs = files.map! { |file| File.dirname(file) }.uniq
changed_subprojects = dirs.map do |dir|
  find_build_script(dir)
end.compact.uniq
puts "~ Changed subprojects: #{changed_subprojects.inspect}"

runner = File.expand_path('../run_tests_parallel.rb', __FILE__)
system(runner, *changed_subprojects) || exit(1)
