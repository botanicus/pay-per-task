#!/usr/bin/env ruby

require 'json'
require 'open-uri'

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

def find_rakefile(dir)
  if File.exist?(File.join("#{dir}/Rakefile"))
    dir
  elsif dir != '.'
    find_rakefile(File.dirname(dir))
  end
end

files = %x{git diff --name-only #{range}}.split("\n")
puts "~ Changed files: #{files.inspect}"
dirs = files.map! { |file| File.dirname(file) }.uniq

changed_subprojects = dirs.map do |dir|
  find_rakefile(dir)
end.compact
puts "~ Changed subprojects: #{changed_subprojects.inspect}"

pids = changed_subprojects.map do |subproject|
  puts "~ Running tests in #{subproject}"
  pid = fork do
    return_value = true
    Dir.chdir(subproject) do
      puts "~ #{subproject}"
      # system 'rake ci:build'
      return_value = system './build.sh' # TODO: replace elsewhere (fid_rakefile)
      5.times { puts }
    end
    exit(return_value ? 0 : 1)
  end
  [subproject, pid]
end

exitstatus = 0
failed = Array.new

pids.each do |(subproject, pid)|
  Process.waitpid(pid)
  unless $?.exitstatus == 0
    exitstatus = 1
    failed << subproject
  end
  puts "Project #{subproject} finished with #{$?.exitstatus}."
end

if exitstatus == 1
  puts "==== ERROR ====="
  p failed
end

exit exitstatus
